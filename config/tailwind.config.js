const colors = require("tailwindcss/colors");
const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim}",
  ],
  darkMode: "class",
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      },
      colors: {
        dark: {
          windows: "#15202b",
          surface: "#29313c",
          onSurface: "#374151",
          txtPrimary: "#fefefe",
          txtSecondary: "#9ca3af",
          link: "#66a9e0",
          primary: "#2ebd85",
          onPrimary: "#fff",
          outgoing: "#008bd0",
        },
        windows: "#f0f2f5",
        surface: "#fff",
        onSurface: "#f9f9f9",
        txtPrimary: "#3b3f42",
        txtSecondary: "#64748b",
        link: "#2770cc",
        primary: "#66a9e0",
        onPrimary: "#fff",
        outgoing: "#008bd0"
      },
      height: {
        desktop: "500px",
        "95p": "95%",
        profile: "8rem",
        phone_profile: "7rem",
        cover: "200px",
        phone_cover: "150px"
      },
      width: {
        "30p": "30%",
        side: "300px",
        desktop: "85%",
        profile: "8rem",
        phone_profile: "7rem",
        message: "70%",
      },
      margin: {
        profile: "-5rem",
        phone_profile: "-3rem"
      }
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/aspect-ratio"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
  ],
};
