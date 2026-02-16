/** @format */

import axios from "axios";


const baseURL = "https://appserver.nafausa.org/api";
const imageUrl = "https://appserver.nafausa.org/";
// const baseURL = "http://localhost:3000/api";
// const imageUrl = "http://localhost:3000/";
export const API = axios.create({ baseURL });

export const getBaseURL = () => baseURL;

export const getImageUrl = () => imageUrl;

export default imageUrl;

