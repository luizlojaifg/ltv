import Route from '@ember/routing/route';

export default class IndexRoute extends Route {
  async model() {

    let response = await fetch('/short_urls.json');
    let {urls}  = await response.json()

     urls =  urls.map((model) => {
       model.short_code = `http://${location.host}/${model.short_code}`

       model.compress_rate = `${Math.round(model.compress_rate * 100)}%`
       //Help to display a url's short name and the full name without
       //breaking the table layout
       model.full_url_show = model.full_url
       if(model.full_url.length > 40){
         model.full_url_show = `${model.full_url.substring(0,40)}...`
       }

       model.updated_at = model.updated_at.replace(/\..*$/,'').replace(/[^0-9:-]/ig,' ')

       return model ;
     });

    return {dado: urls,gosta:"2"};

  }
}
