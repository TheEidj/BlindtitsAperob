import axios from "axios";

const baseURL = import.meta.env.VITE_API_URL
    || (import.meta.env.PROD
            ? "http://37.59.100.208/api"
            : "http://localhost:3000"
    );

const api = axios.create({ baseURL: '/' });

export default api;
