module.exports = {
  content: [
    "./app/views/**/*.{html,erb}",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js"
  ],
  theme: {
    extend: {},
  },
  plugins: [require("daisyui")], // ✅ DaisyUI をプラグインに追加
}