function convertIngredientsUnits(ingredient, sistInter = true) {
  console.log("sistInter: " + sistInter);

        if (!sistInter) {
          console.log(ingredient[1]);
            switch (ingredient[1]) {
              case 'kilogramos':
                ingredient[0] = lbs_to_kg(ingredient[0], sistInter);
                ingredient[1] = "libras";
                  break;
              case 'gramos':
                ingredient[0] = oz_to_g(ingredient[0], sistInter);
                ingredient[1] = "onzas";
                  break;
              case 'litros':
                ingredient[0] = cups_to_l(ingredient[0], sistInter);
                ingredient[1] = "tazas";
                  break;
              case 'mililitros':
                ingredient[0] = liqOnce_to_ml(ingredient[0], sistInter);
                ingredient[1] = "onzas_liquidas";
                break;
            }
          }
          
          if (sistInter) {
            switch (ingredient[1]) {
              case 'libras':
                ingredient[0] = lbs_to_kg(ingredient[0], sistInter);
                ingredient[1] = "kilogramos";
                  break;
              case 'onzas':
                ingredient[0] = oz_to_g(ingredient[0], sistInter);
                ingredient[1] = "gramos";
                  break;
              case 'tazas':
                ingredient[0] = cups_to_l(ingredient[0], sistInter);
                ingredient[1] = "litros";
                  break;
              case 'onzas_liquidas':
                ingredient[0] = liqOnce_to_ml(ingredient[0], sistInter);
                ingredient[1] = "mililitros";
                break;
            }
          }

    
    return ingredient;
  }
 
  function lbs_to_kg(qtty, sistInter = true) {
    
    if (sistInter)
        qtty = qtty * 454;
    else
        qtty = qtty / 454;

    return Number((qtty).toFixed(2));;
  }

  function oz_to_g(qtty, sistInter = true) {
    
    if (sistInter)
        qtty = qtty * 28,35;
    else
        qtty = qtty / 28,35;

    return Number((qtty).toFixed(2));;
  }
  
  function cups_to_l(qtty, sistInter = true) {

    if (sistInter)
        qtty = qtty / 4,227;
    else
        qtty = qtty * 4,227;

    return Number((qtty).toFixed(2));;

  }

  function liqOnce_to_ml(qtty, sistInter = true) {

    if (sistInter)
        qtty = qtty * 29,574;
    else
        qtty = qtty / 29,574;
    
    return Number((qtty).toFixed(2));;
  }


  
  module.exports = { convertIngredientsUnits };