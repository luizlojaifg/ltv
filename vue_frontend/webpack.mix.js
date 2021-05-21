let mix = require('laravel-mix');

mix.setPublicPath('../public/vue')
	.js('src/js/app.js', 'js').vue()
    .sass('src/sass/app.scss', 'css')
	.copy('src/index.html', '')
    .sourceMaps();