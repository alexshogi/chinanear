<template>
  <section
    class="restore-page"
  >
    <v-card class="pa-8">
      <v-row>
        <v-col
          cols="12"
          class="d-flex justify-center pt-5"
        >
          <h1>{{ $t('password-restore-title') }}</h1>
        </v-col>
      </v-row>

      <v-row>
        <v-col cols="12">
          <div class="divider" />
        </v-col>
      </v-row>

      <v-row class="pb-3">
        <v-col cols="12" class="text-center">
          <p>{{ $t('password-restore-text') }}</p>
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
              dense
              label="E-mail"
              outlined
              required
              :rules="emailRules"
            />
          </v-col>
        </v-row>        
      </v-form>

      <v-row>
        <v-col
          v-if="countDown > 0 && countDown < 60"
          style="font-size: 11px; line-height: 16px; text-align: center; color: #9E9E9E;"
        >
          <p>{{ $t('second-request') }} {{ countDown }} {{ $t('seconds-short') }}</p>
        </v-col>
      </v-row>

      <v-row class="mt-8">
        <v-col class="d-flex justify-center">
          <v-btn
            color="primary"
            depressed
            style="letter-spacing: normal; font-weight: 600;"
            :disabled="countDown > 0 && countDown < 60"
            @click="validate"
          >
            {{ $t('send') }}
          </v-btn>
        </v-col>
      </v-row>
    </v-card>
  </section>
</template>

<script>
export default {
  name: 'RestorePage',
  data () {
    return {
      email: '',
      password: '',
      errorMessage: '',
      showPassword: false,
      emailRules: [
        v => !!v || 'E-mail is required',
        v => /.+@.+\..+/.test(v) || 'E-mail must be valid',
      ],
      valid: true,
      countDown: 60,
      sent: false,
    }
  },
  mounted () {
    console.log(this.$route)
  },
  methods: {
    validate () {
      this.$refs.form.validate();

      if (this.valid) {
        this.countDownTimer();
        this.sent = true;
      }
    },
    reset () {
      this.$refs.form.reset();
    },
    resetValidation () {
      this.$refs.form.resetValidation();
    },
    countDownTimer () {
      if (this.countDown > 0) {
        setTimeout(() => {
          this.countDown -= 1;
          this.countDownTimer();
        }, 1000);
      } else {
        this.countDown = 60;
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

  .restore-page {
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
