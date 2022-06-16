const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },

      animation: {
        'fade-out': 'fadeOut 5s ease-in-out forwards',
      },

      keyframes: theme => ({
        fadeOut: {
          '0%': { opacity: 0 },
          '10%': { opacity: 1 },
          '20%': { opacity: 1 },
          '100%': { opacity: 0 },
        },
      }),
    },
  },
  safelist: [
    'bg-blue-600',
    'bg-red-600',
    'bg-yellow-600',
    'bg-green-600',
    'bg-purple-600',
    'align-middle',
    'mr-1',
    'py-2',
    'px-4',
    'inline-block',
    'mt-0',
    'mb-2',
    'leading-tight',
    'font-medium',
    'font-bold',
    'text-white',
    'focus:outline-none',
    'focus:shadow-outline',
    'hover:bg-purple-400',
    'bg-purple-500',
    'shadow',
  ],
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}
