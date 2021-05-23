async function convertIngredientsUnits(ingredient, sistInter = true) {


    if (!sistInter) {
      switch (ingredient) {
        case 'kilogramos':
            ingredient = lbs_to_kg(ingredient, sistInter)
            break;
        case 'gramos':
            ingredient = oz_to_g(ingredient, sistInter)
            break;
        case 'litros':
            ingredient = cups_to_l(ingredient, sistInter)
            break;
        case 'mililitros':
            ingredient = liqOnce_to_ml(ingredient, sistInter)
          break;
        // default:
        //   //Declaraciones ejecutadas cuando ninguno de los valores coincide con el valor de la expresión
        //   break;
      }
    }

    if (sistInter) {
      switch (ingredient) {
        case 'libras':
            ingredient = lbs_to_kg(ingredient, sistInter)
            break;
        case 'onzas':
            ingredient = oz_to_g(ingredient, sistInter)
            break;
        case 'tazas':
            ingredient = cups_to_l(ingredient, sistInter)
            break;
        case 'onzas_liquidas':
            ingredient = liqOnce_to_ml(ingredient, sistInter)
          break;
        // default:
        //   //Declaraciones ejecutadas cuando ninguno de los valores coincide con el valor de la expresión
        //   break;
      }
    }
    return [];
  }
 
  async function lbs_to_kg(qtty, sistInter = true) {
    
    if (sistInter)
        qtty = qtty * 454;
    else
        qtty = qtty / 454;

    return Number((qtty).toFixed(2));;
  }

  async function oz_to_g(qtty, sistInter = true) {
    
    if (sistInter)
        qtty = qtty * 28,35;
    else
        qtty = qtty / 28,35;

    return Number((qtty).toFixed(2));;
  }
  
  async function cups_to_l(qtty, sistInter = true) {

    if (sistInter)
        qtty = qtty / 4,227;
    else
        qtty = qtty * 4,227;

    return Number((qtty).toFixed(2));;

  }
  async function liqOnce_to_ml(qtty, sistInter = true) {

    if (sistInter)
        qtty = qtty * 29,574;
    else
        qtty = qtty / 29,574;
    
    return Number((qtty).toFixed(2));;
  }


  
  module.exports = { checkImgFromAPI };