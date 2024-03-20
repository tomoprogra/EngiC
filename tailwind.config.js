module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  plugins: [require("daisyui")],
  theme: {
    extend: {
      height: {
        '144': '36rem', 
      },
      width: {
        '144': '36rem',
        '13' :  '3.25rem',
        '17' :  '4.25rem',
      },
      fontSize: {
        'xxs': '9px', 
        'xxxs': '7px', 
      },
    }
  },
  daisyui: {
    themes: false,
  },
}
