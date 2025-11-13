import swaggerJSDoc from "swagger-jsdoc";

const options = {
  definition: {
    openapi: "3.0.0",
    info: {
      title: "Persada ESS API",
      version: "1.0.0",
      description: "RESTful API (Supabase) untuk Persada ESS",
    },
    servers: [
      {
        url: "http://localhost:3000",
      },
    ],
  },

  // IMPORTANT: Swagger akan scan seluruh file routes
  apis: ["./routes/*.js"],
};

export const swaggerSpec = swaggerJSDoc(options);
