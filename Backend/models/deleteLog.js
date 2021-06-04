const config = require("config");
const mongoose = require("mongoose");
const Joi = require("joi");

const deleteLogSchema = new mongoose.Schema({
  motivo: {
    type: String,
    required: true,
  },
}, {
    timestamps: true
});

const DeleteLog = mongoose.model("DeleteLog", deleteLogSchema);

function validateDeleteLog(deleteLog) {
  const schema = {
    usuario: Joi.String().required(),
  };
  return Joi.validate(deleteLog, schema);
}

exports.DeleteLog = DeleteLog;
exports.Validate = validateDeleteLog;
