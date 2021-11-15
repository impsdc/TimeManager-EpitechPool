import axios from "axios";

export default axios.create({
    baseURL: process.env.VUE_APP_API_URL,
    withCredentials: true,
});

axios.interceptors.response.use(
  //successful callback, we don't need to do anything
  (response) => {
    return response;
  },
  //check if we received a 401 and redirect
  (error) => {
      if (401 === error.response.status) {
        return error.response.data.error
    } else {
      return Promise.reject(error);
    }
  }
);
