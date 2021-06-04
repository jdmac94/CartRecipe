const translate = require("@vitalets/google-translate-api");

const translateTo = (word, lenguage) => {
  translate(word, { to: lenguage })
    .then((res) => {
      return res.text;
    })
    .catch((err) => {
      return err;
    });
};

module.exports = { translateTo };
