const fetch = require("node-fetch");
let OFFurl = "https://world.openfoodfacts.org/api/v0/product/";

async function getImgByAPI(code) {
  // console.log("getImgByAPI");
  let url = OFFurl + code + ".json";
  // console.log(url);

  var fotos = fetch(url)
    .then(function (response) {
      return response.json();
    })
    .catch(function (error) {
      console.log("Hubo un problema con la petición Fetch:" + error.message);
      return undefined;
    });
  // console.log("fotos");
  //console.log(fotos);
  return fotos;
}

async function checkImgFromAPI(code) {
  // console.log("checkImgFromAPI");
  var fotos = await getImgByAPI(code);

  return [fotos?.product?.selected_images?.front?.display] ?? [];
}

module.exports = { checkImgFromAPI };
