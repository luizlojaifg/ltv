<template>
  <div class="row items-center" style="padding: 2%"  >
    <div class="col-md-2" > </div>
    <div class="col-xs-12 col-sm-6 col-md-4" style="order: 2">
      <q-card class="my-card bg-primary text-white" style="margin-bottom: 10px" >
        <q-card-section>
          <div class="text-h3" style="text-align: center" >Short URL with Ltv</div>
          <div class="text-subtitle2" style="text-align: center">Make your url shorter and be Happy!</div>
        </q-card-section>

        <q-card-section>
          <q-input bottom-slots v-model="url" label="Write your URL right below and click in the check on the right!" counter dark>
            <template v-slot:before>
              <q-avatar>
                <img src="img/ltvLogo.jpg">
              </q-avatar>
            </template>

            <template v-slot:append>
              <q-icon v-if="url !== ''" name="close" @click="url = ''" class="cursor-pointer" />
            </template>

            <template v-slot:hint>
              Your url will be shorter than you think ;).
            </template>

            <template v-slot:after>
              <q-btn round dense flat icon="done_outline" @click="makeUrlShorter" />
            </template>
          </q-input>
        </q-card-section>

        <q-separator dark />

        <q-card-actions align="center">
          <q-btn :loading="progress" @click="makeUrlShorter" flat style="width: 150px">
            Make It Shorter!
            <template v-slot:loading>
              <q-spinner-hourglass class="on-left" />
              Wait, please!
            </template>
          </q-btn>


        </q-card-actions>
      </q-card>


        <q-table
            class="my-sticky-dynamic"
            title="Ltv's 100 most accessed Urls."
            :data="data"
            :columns="columns"
            :loading="loading"
            row-key="short_code"
        />



    </div>
    <div class="col-md-2">

    </div>
  </div>
</template>

<script>
export default{
  name:"ViewLogin",
  data(){
    return {
      data:[],
      nextPage:0,
      loading: false,
      url:"http://www.google.com.br",
      progress: false,
      pagination: {
        rowsPerPage: 0
      },
      columns: [
        {name: 'title',label: 'Title',align: 'left', field: 'title'},
        { name: 'full_url', align: 'center', label: 'Full URL', field: 'full_url', sortable: true },
        { name: 'short_code', align: 'center', label: 'Short URL', field: 'short_code', sortable: true,  format: (val, row) => `http://${location.host}/${val}` },
        { name: 'click_count', align: 'center', label: 'Times Accessed', field: 'click_count', sortable: true },
        { name: 'updated_at', align: 'center', label: 'Last Time Accessed', field: 'updated_at', sortable: true,  format: (val, row) => this.moment(val ,"YYYY-MM-DD HH:mm:ss").format('YYYY-MM-DD HH:mm:ss') }
      ]

    }
  },
  mounted(){
    this.onRequest({
    })
  },
  methods: {
    onRequest (props) {
      this.loading = true

      this.$http.get(`/short_urls.json`,{
        params:{
        }
      }).then(res => {
        this.data =  res.data["urls"]

        this.loading = false
      })

    },
    makeUrlShorter(){
      this.progress = true

      this.$http.post('/short_urls.json',{

          full_url:this.url

      }).then(res => {
        this.progress = false

        if(res["data"]["short_code"]){

          let shortCode = res["data"]["short_code"]

          this.onRequest({})

          this.$q.notify({
            message: `Here is your super Shorter URL!`,
            multiLine: true,
            progress: true,
            timeout: 10000,
            caption: `http://${location.host}/${shortCode}`,
            position: "top",
            type: 'positive',
            avatar: 'img/ltvLogo.jpg',
            actions: [
              { label: 'Copy', color: 'yellow', handler: () => { this.$copyText(`http://${location.host}/${shortCode}`) } },
              { label: 'Dismiss', color: 'white', handler: () => {  } }
            ]
          })

        }else{
          this.url = ""

          this.$q.notify({
            message: `The URL is invalid!`,
            caption: `Please, try another one!`,
            multiLine: true,
            progress: true,
            timeout: 2000,
            position: "top",
            type: 'negative',
            avatar: 'img/ltvLogo.jpg'
          })

        }

      })

    }
  }
}
</script>

<style>
.container{
  display: flex;
  flex-direction: row;
  align-items: flex-end;
}

.item {
  align-self: center;
}

</style>