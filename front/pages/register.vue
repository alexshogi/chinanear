<template>
  <section
    class="register-page"
  >
    <v-card class="pa-4">
      <v-row>
        <v-col
          cols="12"
          class="d-flex justify-center pt-5"
        >
          <img src="../static/logo.png" alt="China Near">
        </v-col>
      </v-row>

      <v-row>
        <v-col cols="12">
          <div class="divider" />
        </v-col>
      </v-row>

      <v-row>
        <v-col cols="12">
          <h1>{{ $t('registration') }}</h1>
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
          <v-col cols="6" class="py-0">
            <v-text-field
              v-model="email"
              dense
              label="E-mail"
              :hint="$t('email-hint')"
              persistent-hint
              outlined
              :rules="emailRules"
            />
          </v-col>
          <v-col cols="6" class="py-0">
            <v-text-field
              v-model="phone"
              dense
              :label="$t('phone')"
              outlined
              :rules="[rules.required]"
            />
          </v-col>
        </v-row>

        <v-row>
          <v-col cols="6" class="py-0">
            <v-text-field
              v-model="name"
              dense
              :label="$t('name')"
              outlined
              :rules="[rules.required]"
            />
          </v-col>
          <v-col cols="6" class="py-0">
            <v-text-field
              v-model="surname"
              dense
              :label="$t('surname')"
              outlined
              :rules="[rules.required]"
            />
          </v-col>
        </v-row>

        <v-row>
          <v-col cols="12" class="py-0">
            <p>{{ $t('company-name-hint') }}</p>
            <v-text-field
              v-model="companyName"
              dense
              :label="$t('company-name')"
              outlined
              :rules="[rules.required]"
            />
          </v-col>
        </v-row>

        <v-row>
          <p class="px-3">{{ $t('company-name-marketplace-hint') }}</p>
          <v-col cols="6" class="py-0">
            <v-text-field
              v-model="companyMarketNameRu"
              dense
              :label="$t('company-name-marketplace')"
              outlined
              :rules="[rules.required]"
            />
          </v-col>
          <v-col cols="6" class="py-0">
            <v-text-field
              v-model="companyMarketNameEn"
              dense
              :label="$t('company-name-marketplace-eng')"
              outlined
              :rules="[rules.required]"
            />
          </v-col>
        </v-row>

        <v-row>
          <p class="px-3">{{ $t('address-hint') }}</p>
          <v-col cols="4" class="py-0">
            <v-text-field
              v-model="postcode"
              dense
              :label="$t('postcode')"
              outlined
              :rules="[rules.required]"
            />
          </v-col>
          <v-col cols="4" class="py-0">
            <v-text-field
              v-model="country"
              dense
              :label="$t('country')"
              outlined
              :rules="[rules.required]"
            />
          </v-col>
          <v-col cols="4" class="py-0">
            <v-text-field
              v-model="city"
              dense
              :label="$t('city')"
              outlined
              :rules="[rules.required]"
            />
          </v-col>
        </v-row>

        <v-row>
          <v-col cols="6" class="py-0">
            <v-text-field
              v-model="street"
              dense
              :label="$t('street')"
              outlined
              :rules="[rules.required]"
            />
          </v-col>
          <v-col cols="3" class="py-0">
            <v-text-field
              v-model="house"
              dense
              :label="$t('house')"
              outlined
              :rules="[rules.required]"
            />
          </v-col>
          <v-col cols="3" class="py-0">
            <v-text-field
              v-model="building"
              dense
              :label="$t('building')"
              outlined
            />
          </v-col>
        </v-row>

        <v-row>
          <v-col cols="6" class="py-0">
            <v-text-field
              v-model="password"
              dense
              :hint="$t('password-hint')"
              :label="$t('set-password')"
              outlined
              persistent-hint
              :rules="passwordRules"
            />
          </v-col>
          <v-col cols="6" class="py-0">
            <v-text-field
              v-model="passwordConfirm"
              dense
              :label="$t('confirm-password')"
              outlined
              :rules="passwordConfirmRules"
            />
          </v-col>
        </v-row>
      </v-form>

      <v-row>
        <v-col cols="12" class="d-flex justify-center">
          <v-btn
            color="primary"
            depressed
            style="letter-spacing: normal; width: 100%; color: #FFFFFF; font-weight: 600; font-size: 14px; line-height: 17px; padding: 20px; width: fit-content"
            @click="validate"
          >
            <v-progress-circular
              v-if="loading"
              indeterminate
              size="20"
              width="2"
              color="white"
            />
            <span v-else>{{ $t('register') }}</span>
          </v-btn>
        </v-col>
      </v-row>
    </v-card>

    <v-snackbar
      v-model="snackbar"
      :timeout="4000"
    >
      {{ $t('register-success-message') }}
    </v-snackbar>
  </section>
</template>

<script>
export default {
  name: 'RegisterPage',
  data () {
    return {
      loading: false,
      snackbar: false,
      email: '',
      phone: '',
      name: '',
      surname: '',
      companyName: '',
      companyMarketNameRu: '',
      companyMarketNameEn: '',
      postcode: '',
      country: '',
      city: '',
      street: '',
      house: '',
      building: '',
      password: '',
      passwordConfirm: '',
      rules: {
        required: value => !!value || 'Required',
      },
      emailRules: [
        v => !!v || 'E-mail is required',
        v => /.+@.+\..+/.test(v) || 'E-mail must be valid',
      ],
      passwordRules: [
        value => !!value || 'Required',
        value => (value && /\d/.test(value)) || 'At least one digit',
        value => (value && /[A-Z]{1}/.test(value)) || 'At least one capital letter',
        value => (value && /[^A-Za-z0-9]/.test(value)) || 'At least one special character',
        value => (value && value.length >= 8 ) || 'Minimum 8 characters',
      ],
      passwordConfirmRules: [
        v => !!v || 'Confirm password',
        v => v === this.password || 'Passwords must match'
      ],
      errorMessage: '',
      valid: true,
    }
  },
  methods: {
    validate () {
      this.$refs.form.validate();

      if (this.valid) {
        this.register();
      }
    },
    reset () {
      this.$refs.form.reset();
    },
    resetValidation () {
      this.$refs.form.resetValidation();
    },
    async register () {
      this.loading = true;

      const graphqlQuery = {
        query: `
          mutation {
            createUser(data: {
              name: "${this.name}",
              surname: "${this.surname}",
              email: "${this.email}",
              companyName: "${this.companyName}",
              companyMarketNameRu: "${this.companyMarketNameRu}",
              companyMarketNameEn: "${this.companyMarketNameEn}",
              postcode: "${this.postcode}",
              country: "${this.country}",
              city: "${this.city}",
              street: "${this.street}",
              house: "${this.house}",
              building: "${this.building}",
              password: "${this.password}"
            }) {
              email
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

      const email = result.data?.createUser?.email;

      if (email) {
        this.snackbar = true;

        setTimeout(() => {
          this.snackbar = false;
          this.$router.push({ path: '/auth' });
        }, 4000);
      }
    },
  }
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

  .register-page {
    width: 960px;
    min-height: 400px;
    margin-top: 40px;
    margin-left: auto;
    margin-right: auto;
    padding: 0 96px;

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
