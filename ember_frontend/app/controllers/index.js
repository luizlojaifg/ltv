import Controller from '@ember/controller';
import {tracked} from "@glimmer/tracking";
import {action} from '@ember/object';
import Store from '@ember-data/store';

export default class IndexController extends Controller {

  @tracked url = "";
  @tracked short_code = "";
  @tracked errors = []
  @tracked convert_successfuly = false;
  @tracked convert_wrongly = false;

  @action
  async shrinkUrl(element){


      let response = await fetch(`/short_urls?full_url=${this.url}`,{method:"post", parameters:{full_url:this.url}});
      let data = await response.json();
      if(data["short_code"]){
        this.short_code = `${location.host}/${data["short_code"]}`
        this.convert_successfuly = true;
        this.convert_wrongly = false;

      }else {
        this.errors = data["errors"]
        this.convert_successfuly = false;
        this.convert_wrongly = true;
      }

    }

    @action
    updateUrl(event){
      if(event.target.value != ""){
        this.url = event.target.value
      }else{
        this.convert_successfuly = false;
        this.convert_wrongly = false;
      }


    }

}
