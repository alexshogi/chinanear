<template>
  <v-container
    ref="page"
    class="chat-page"
    style="margin-top: 70px;"
  >
  <chat-window
      height="650px"
      :current-user-id="currentUserId"
      :rooms="rooms"
      :rooms-loaded="roomsLoaded"
      :loading-rooms="loadingRooms"
      :messages="messages"
      :messages-loaded="messagesLoaded"
      :show-search="false"
      :show-files="false"
      :show-audio="false"
      :show-add-room="false"
      :show-emojis="false"
      :show-reaction-emojis="false"
      @fetch-messages="onFetchMessages"
      @send-message="onSendMessage"
    />
  </v-container>
</template>

<script>
import { format } from 'date-fns';
import { mapGetters, mapActions } from 'vuex';
import ChatWindow from 'vue-advanced-chat';
import 'vue-advanced-chat/dist/vue-advanced-chat.css';

export default {
  name: 'ChatPage',
  components: {
    ChatWindow,
  },
  data() {
    return {
      roomsLoaded: false,
      messagesLoaded: false,
      loadingRooms: false,
      messages: [],
      rooms: [],
      sellerId: null,
    }
  },
  computed: {
    ...mapGetters({
      user: 'user'
    }),
    currentUserId () {
      return this.user?.id;
    },
  },
  created () {
    const sellerId = this.$route.query.seller;

    this.sellerId = sellerId;
  },
  async mounted () {
    const auth = localStorage.getItem('auth');

    if (auth) {
      await this.setAuth(JSON.parse(auth));
    }

    this.getRooms();

    if (this.sellerId && this.sellerId !== this.currentUserId) {
      this.checkRoomExistance();
    }
  },
  methods: {
    ...mapActions({
      setAuth: 'login',
    }),
    getDate (date) {
      return format(new Date(date), 'dd LLLL');
    },
    getTime (date) {
      return format(new Date(date), 'HH:mm');
    },
    async checkRoomExistance () {
      const graphqlQuery = {
        query: `
          query {
            chatRoom(
              where: {
                buyer_seller: "${this.currentUserId}_${this.sellerId}"
              }
            ) {
              id
            }
          }
        `
      };

      const response = await this.$axios({
        method: 'POST',
        data: JSON.stringify(graphqlQuery)
      });

      console.log('Check room response', response);

      const chatRoom = response?.data?.data?.chatRoom;

      if (chatRoom) {
        // chat room already exists
        console.log('chat room already exists');

      } else {
        // no room, create
        console.log('no room, create');
        this.createRoom();
      }
    },
    async generateRoomName () {
      const graphqlQuery = {
        query: `
          query {
            user (
              where: {
                id: "${this.sellerId}"
              }
            ) {
              name
              surname
              companyName
              companyMarketNameRu
              companyMarketNameEn
            }
          }
        `
      };

      const response = await this.$axios({
        method: 'POST',
        data: JSON.stringify(graphqlQuery)
      });

      console.log('Get seller response', response);

      const seller = response?.data?.data?.user;

      return `${seller.name} ${seller.surname} / ${this.user.name} ${this.user.surname}`;
    },
    async createRoom () {
      const name = await this.generateRoomName();

      const graphqlQuery = {
        query: `
          mutation {
            createChatRoom (
              data: {
                roomName: "${name}"
                users: {
                  connect: [
                    { id: "${this.currentUserId}" }
                    { id: "${this.sellerId}" }
                  ]
                }
                buyer_seller: "${this.currentUserId}_${this.sellerId}"
              }
            ) {
              id
              roomName
              users {
                id
                name
                surname
                companyName
                companyMarketNameRu
                companyMarketNameEn
              }
              usersCount
            }
          }
        `
      };

      const response = await this.$axios({
        method: 'POST',
        data: JSON.stringify(graphqlQuery)
      });

      console.log('Create room response', response);

      const chatRoom = response?.data?.data?.createChatRoom;

      if (chatRoom) {
        this.getRooms();
      } else {
        // TODO: Show error popup
      }
    },
    async getRooms () {
      this.loadingRooms = true;
      this.roomsLoaded = false;

      const graphqlQuery = {
        query: `
          query {
            chatRooms (
              where: {
                users: {
                  some: {
                    id: {
                      equals: "${this.user.id}"
                    }
                  }
                }
              }
            ) {
              id
              roomName
              users {
                id
                name
                email
                surname
                role
                companyName
                companyMarketNameRu
                companyMarketNameEn
              }
              usersCount
            }
          }
        `
      };

      const response = await this.$axios({
        method: 'POST',
        data: JSON.stringify(graphqlQuery)
      });

      console.log('Get rooms response', response);

      const chatRooms = response?.data?.data?.chatRooms;

      if (chatRooms) {
        for (const r of chatRooms) {
          r.roomId = r.id;

          for (const user of r.users) {
            user._id = user.id;
            user.username = `${user.name} ${user.surname}`;
          }
        }

        this.rooms = [ ...chatRooms ];

        this.roomsLoaded = true;
      } else {
        // TODO: Show error popup
      }

      this.loadingRooms = false;
    },
    async getMessages (roomId) {
      this.messagesLoaded = false;

      const graphqlQuery = {
        query: `
          query {
            chatMessages (
              where: {
                room: {
                  id: {
                    equals: "${roomId}"
                  }
                }
              }
            ) {
              id
              content
              sender {
                id
                name
                surname
                companyName
                companyMarketNameRu
                companyMarketNameEn
              }
              date
              system
              saved
              distributed
              seen
              deleted
              disableActions
              disableReactions
            }
          }
        `
      };

      const response = await this.$axios({
        method: 'POST',
        data: JSON.stringify(graphqlQuery)
      });

      console.log('Get messages response', response);

      const chatMessages = response?.data?.data?.chatMessages;

      if (chatMessages) {
        for (const m of chatMessages) {
          m._id = m.id;
          m.senderId = m.sender.id;
          m.username = m.sender.name + m.sender.surname;

          const temp = m.date;

          m.date = this.getDate(temp);
          m.timestamp = this.getTime(temp);
        }

        this.messages = [ ...chatMessages ];

        this.messagesLoaded = true;
      } else {
        // TODO: Show error popup
      }
    },
    async sendMessage ({ roomId, content }) {
      const graphqlQuery = {
        query: `
          mutation {
            createChatMessage (
              data: {
                content: "${content}"
                room: {
                  connect: {
                    id: "${roomId}"
                  }
                }
                sender: {
                  connect: {
                    id: "${this.currentUserId}"
                  }
                }
              }
            ) {
              id
              content
              sender {
                id
                name
                surname
                companyName
                companyMarketNameRu
                companyMarketNameEn
              }
              date
              system
              saved
              distributed
              seen
              deleted
              disableActions
              disableReactions
            }
          }
        `
      };

      const response = await this.$axios({
        method: 'POST',
        data: JSON.stringify(graphqlQuery)
      });

      console.log('Create message response', response);

      const chatMessage = response?.data?.data?.createChatMessage;

      if (chatMessage) {
        this.getMessages(roomId);
      }
    },
    onFetchMessages({ room, options }) {
      this.messages = [];
      this.getMessages(room.id);
    },
    onSendMessage ({ roomId, content }) {
      console.log('** onSendMessage');
      console.log(roomId, content);
      this.sendMessage({ roomId, content });
    },
  }
}
</script>
