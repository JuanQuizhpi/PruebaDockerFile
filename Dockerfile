# Contruccióm del frontend y preparación del servidor Node.js
FROM node:latest AS node-builder

#Cración del directorio de trabajo para el front-end.
WORKDIR /frontend-app/frontendprueba64

#Copiamos el todo el contenido de nuestro frontend al directorio /frontend-app/frontendchatapp
COPY frontendprueba64 /frontend-app/frontendprueba64

#Instalamos las dependencias del frontend con npm, ademas forzamos la instalacion de estas en caso de ser necesario
RUN npm install --force

#Creamos el directorio de trabajo /frontend-app/server para ell servidor de node.js
WORKDIR /frontend-app/server

#Copiamos los archivos package.json y package-lock.json a nuestra directorio de trabajo servidor
COPY package*.json /frontend-app/server

#Instalamos todas las dependecias para nuestro servidor
RUN npm install

#Copiamos el archivo index.js que contiene la configuración de nuestro servidor a nuestro directorio de trabajo servidor
COPY index.js /frontend-app/server

#Configuración de nginx y combinación con el servidor de node.js
FROM nginx:1.17.1-alpine

#Instalación de node.js y np, en el contenedor de nginx
RUN apk add --update nodejs npm

#Copiamos los archivos construidos en /frontend-app/frontendchatapp al directorio de nginx
COPY --from=node-builder /frontend-app/frontendprueba64/dist/frontendprueba64/browser /usr/share/nginx/html

#Copiamos los archivos del servidor Node.js desde /frontend-app/server/ al contenedor de nginx
COPY --from=node-builder /frontend-app/server/ /frontend-app/server

#Generamos el comando para ejecutar el servidor Node.js en segundo plano y nginx en primer plano
CMD ["sh", "-c", "node /frontend-app/server/index.js & nginx -g 'daemon off;'"]

# Expone el puerto 80 para el tráfico HTTP
EXPOSE 80

# Expone el puerto 4000 para el servidor Node.js
EXPOSE 4000