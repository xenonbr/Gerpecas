/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#E52421',
          hover: '#C81B18',
          dark: '#9E1210',
          subtle: 'rgba(229, 36, 33, 0.08)',
        },
        dark: {
          DEFAULT: '#111111',
          surface: '#1E1E1E',
          card: '#252525',
        }
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
        sport: ['Chakra Petch', 'sans-serif'],
      },
      keyframes: {
        marquee: {
          '0%': { transform: 'translateX(0%)' },
          '100%': { transform: 'translateX(-50%)' },
        },
      },
      animation: {
        marquee: 'marquee 65s linear infinite',
      },
    },
  },
  plugins: [],
}
