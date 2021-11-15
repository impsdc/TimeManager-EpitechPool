module.exports = {
  purge: ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}'],
  darkMode: 'class',
  //darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
  },
  variants: {
    extend: {
      tableLayout: ['hover', 'focus'],
      borderCollapse: ['hover', 'focus'],
    },
  },
  plugins: [],
  corePlugins: {
    borderCollapse: false,
  },
}


