/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./app/views/**/*.erb",
    "./public/js/*.js"
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/forms')
  ],
  darkMode: 'class'
}

