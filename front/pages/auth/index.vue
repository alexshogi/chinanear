<template>
  <section
    class="auth-page"
  >
    <v-card class="pa-8">
      <v-row>
        <v-col
          cols="12"
          class="d-flex justify-center pt-5"
        >
          <img src="../../static/logo.png" alt="China Near">
        </v-col>
      </v-row>

      <v-row>
        <v-col cols="12">
          <div class="divider" />
        </v-col>
      </v-row>

      <v-row class="pb-3">
        <v-col cols="12" class="red--text text-center">
          {{ errorMessage }}
        </v-col>
      </v-row>

      <v-form
        ref="form"
        v-model="valid"
        lazy-validation
      >
        <v-row>
          <v-col cols="12" class="py-0">
            <v-text-field
              v-model="email"
              dense
              label="email"
              outlined
              :rules="emailRules"
            />
          </v-col>
        </v-row>

        <v-row>
          <v-col cols="12" class="py-0">
            <v-text-field
              v-model="password"
              dense
              label="password"
              outlined
              :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
              :rules="[rules.required, rules.min]"
              :type="showPassword ? 'text' : 'password'"
              @click:append="showPassword = !showPassword"
            />
          </v-col>
        </v-row>
      </v-form>

      <v-row>
        <v-col cols="6" class="text-left">
          <NuxtLink
            to="auth/restore"
            style="text-decoration: none; font-size: 14px;"
          >
            {{ $t('forgot-password') }}
          </NuxtLink>
        </v-col>

        <v-col cols="6" class="text-right">
          <NuxtLink
            to="/register"
            style="text-decoration: none; font-size: 14px;"
          >
            {{ $t('register') }}
          </NuxtLink>
        </v-col>
      </v-row>

      <v-row class="mt-8">
        <v-col class="d-flex justify-center">
          <v-btn
            color="primary"
            depressed
            style="letter-spacing: normal; font-weight: 600;"
            @click="validate"
          >
            <v-progress-circular
              v-if="loading"
              indeterminate
              size="20"
              width="2"
              color="white"
            />
            <span v-else>{{ $t('login') }}</span>
          </v-btn>
        </v-col>
      </v-row>
    </v-card>
  </section>
</template>

<script>
import { mapActions } from 'vuex'

export default {
  name: 'AuthPage',
  data () {
    return {
      loading: false,
      email: '',
      password: '',
      errorMessage: '',
      showPassword: false,
      rules: {
        required: value => !!value || 'Required',
        min: v => v.length >= 8 || 'Min 8 characters',
      },
      emailRules: [
        v => !!v || 'E-mail is required',
        v => /.+@.+\..+/.test(v) || 'E-mail must be valid',
      ],
      valid: true,
    }
  },
  mounted () {
    console.log(this.$route)
  },
  methods: {
    ...mapActions({
      setAuth: 'login'
    }),
    validate () {
      this.$refs.form.validate();

      if (this.valid) {
        this.login();
      }
    },
    reset () {
      this.$refs.form.reset();
    },
    resetValidation () {
      this.$refs.form.resetValidation();
    },
    async login () {
      this.loading = true;

      const graphqlQuery = {
        query: `
          mutation {
            authenticateUserWithPassword(
              email: "${this.email}"
              password: "${this.password}"
            ) {
              __typename
              ... on UserAuthenticationWithPasswordSuccess {
                sessionToken
                item {
                  id
                  name
                  email
                  surname
                  role
                  companyName
                  companyMarketNameRu
                  companyMarketNameEn
                  postcode
                  country
                  city
                  street
                  house
                  building
                }
              }
              ... on UserAuthenticationWithPasswordFailure {
                message
              }
            }
          }
        `
      };

      const response = await this.$axios({
        method: 'POST',
        data: JSON.stringify(graphqlQuery)
      });

      const result = response.data;

      this.loading = false;

      if (result?.data?.authenticateUserWithPassword?.message) {
        this.errorMessage = result.data.authenticateUserWithPassword.message;
        console.log('error', this.errorMessage);
      }

      if (result?.data?.authenticateUserWithPassword?.item && result?.data?.authenticateUserWithPassword?.sessionToken) {
        const user = result.data.authenticateUserWithPassword.item;
        const sessionToken = result.data.authenticateUserWithPassword.sessionToken;

        console.log('user', user);
        console.log('sessionToken', sessionToken);

        this.setAuth({
          user: user,
          sessionToken: sessionToken
        })

        this.$router.push({ path: '/' });
      }
    }
  },
}
</script>

<style>
  .v-text-field__details {
    padding: 0 !important;
  }
</style>

<style lang="scss" scoped>
  .divider {
    height: 1px;
    width: 100%;
    background-color: #E0E0E0;
  }

  .auth-page {
    width: 500px;
    min-height: 400px;
    margin-top: 40px;
    margin-left: auto;
    margin-right: auto;
    padding: 0 20px;

    h1 {
      font-weight: 600;
      font-size: 20px;
      line-height: 27px;
      text-align: center;
      color: #616161;
    }

    p {
      font-weight: 400;
      font-size: 14px;
      line-height: 20px;
      color: #616161;
    }
  }
</style>
