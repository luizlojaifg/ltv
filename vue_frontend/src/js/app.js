import Vue from 'vue';

import Quasar from 'quasar';
import Chart from 'chart.js';
import _ from 'lodash'
import VueClipboard from 'vue-clipboard2'
import moment from "moment";

Vue.use(Quasar);
Vue.use(VueClipboard)


import '../plugins/axios'
import router from '../router/routes'
// Components .
import Layout from './components/Layout'







Vue.component('layout', Layout);






Vue.filter('dataHora', valor =>{
    var m = require("moment")
    valor = valor != null?m(valor,"YYYY-MM-DD HH:mm:ss").format("DD/MM/Y HH:mm:ss"):"-";
    return valor
})

Vue.filter('tempo', valor =>{
    var m = require("moment")
    return valor != null?m(valor,"YYYY-MM-DD HH:mm:ss").format("HH:mm:ss"):"-";
})



Vue.prototype.moment = moment





new Vue({
    router,
    el: '#q-app',
    data () {
        return {
            drawer: false,
            menuList: [
                {
                    icon: 'inbox',
                    label: 'Inbox',
                    separator: true
                },
                {
                    icon: 'send',
                    label: 'Outbox',
                    separator: false
                },
                {
                    icon: 'delete',
                    label: 'Trash',
                    separator: false
                },
                {
                    icon: 'error',
                    label: 'Spam',
                    separator: true
                },
                {
                    icon: 'settings',
                    label: 'Settings',
                    separator: false
                },
                {
                    icon: 'feedback',
                    label: 'Send Feedback',
                    separator: false
                },
                {
                    icon: 'help',
                    iconColor: 'primary',
                    label: 'Help',
                    separator: false
                }
            ]
        }
    }
});