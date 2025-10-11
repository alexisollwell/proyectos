import express from "express";
import fetch from "node-fetch";
import dotenv from "dotenv";
import cors from "cors";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors()); // permite llamadas desde Flutter
app.use(express.json());

let accessToken = null;
let tokenExpiration = null;

//Para obtener nuevo token desde Spotify
async function getAccessToken() {
  // Si el token actual aún es válido se reutiliza
  if (accessToken && tokenExpiration && Date.now() < tokenExpiration) {
    return accessToken;
  }

  const response = await fetch("https://accounts.spotify.com/api/token", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      Authorization:
        "Basic " +
        Buffer.from(
          process.env.CLIENT_ID + ":" + process.env.CLIENT_SECRET
        ).toString("base64"),
    },
    body: "grant_type=client_credentials",
  });

  if (!response.ok) {
    throw new Error("Error obteniendo token de Spotify");
  }

  const data = await response.json();
  accessToken = data.access_token;
  tokenExpiration = Date.now() + data.expires_in * 1000;

  return accessToken;
}

//Endpoint para verificar que el backend funciona
app.get("/", (req, res) => {
  res.send("Backend de SpotiFinder funcionando 🚀");
});

//Endpoint para buscar canciones/artistas
app.get("/search", async (req, res) => {
  const q = req.query.q;
  const type = req.query.type || "track";

  if (!q) {
    return res.status(400).json({ error: "Falta parámetro q" });
  }

  try {
    const token = await getAccessToken();

    const response = await fetch(
      `https://api.spotify.com/v1/search?q=${encodeURIComponent(
        q
      )}&type=${type}&limit=10`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      }
    );

    const data = await response.json();

    if (data.error) {
      return res.status(500).json({ error: data.error });
    }

    res.json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.listen(PORT, () => {
  console.log(`Backend corriendo en http://localhost:${PORT}`);
});
