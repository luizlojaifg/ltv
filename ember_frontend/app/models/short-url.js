import Model from '@ember-data/model';

export default class ShortUrlModel extends Model {

  @attr title;
  @attr full_url;
  @attr short_code;
  @attr compress_rate;
  @attr updated_at;

  get show_compact_url(){
    if(this.full_url.length > 40){
      return  `${this.full_url.substring(0,40)}...`
    }else{
      return this.full_url
    }
  }

  get compress_rate_percentage(){
    return `${Math.round(this.compress_rate * 100)}%`
  }

  get short_code_with_host(){
    return `http://${location.host}/${this.short_code}`

  }

}
