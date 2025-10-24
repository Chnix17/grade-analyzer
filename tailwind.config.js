/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{js,jsx,ts,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#f0f9f4',
          100: '#dbf0e3',
          200: '#b9e1c9',
          300: '#8ccba7',
          400: '#5daf82',
          500: '#3A6F43',
          600: '#2f5a37',
          700: '#26462c',
          800: '#1f3723',
          900: '#1a2e1d',
        },
      },
    },
  },
  plugins: [],
}
