import Vue from 'vue'
import Router from  'vue-router'

import shortURL from '../js/components/ViewShortURL'


Vue.use(Router)

export default new Router({
    routes : [
        {
            path: '/',
            component: shortURL
        }
    ]
})


