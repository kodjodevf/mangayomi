// https://github.com/LNReader/lnreader/blob/master/src/plugins/types/filterTypes.ts

let FilterTypes

;(function(FilterTypes) {
  FilterTypes["TextInput"] = "Text"
  FilterTypes["Picker"] = "Picker"
  FilterTypes["CheckboxGroup"] = "Checkbox"
  FilterTypes["Switch"] = "Switch"
  FilterTypes["ExcludableCheckboxGroup"] = "XCheckbox"
})(FilterTypes || (FilterTypes = {}))

module.exports.isPickerValue = q => {
  return q.type === FilterTypes.Picker && typeof q.value === "string"
}

module.exports.isCheckboxValue = q => {
  return q.type === FilterTypes.CheckboxGroup && Array.isArray(q.value)
}

module.exports.isSwitchValue = q => {
  return q.type === FilterTypes.Switch && typeof q.value === "boolean"
}

module.exports.isTextValue = q => {
  return q.type === FilterTypes.TextInput && typeof q.value === "string"
}

module.exports.isXCheckboxValue = q => {
  return (
    q.type === FilterTypes.ExcludableCheckboxGroup &&
    typeof q.value === "object" &&
    !Array.isArray(q.value)
  )
}

module.exports.FilterTypes = {
  "TextInput": "Text",
  "Picker": "Picker",
  "CheckboxGroup": "Checkbox",
  "Switch": "Switch",
  "ExcludableCheckboxGroup": "XCheckbox"
};
