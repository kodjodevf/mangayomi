// https://github.com/LNReader/lnreader/blob/master/src/plugins/types/filterTypes.ts

export let FilterTypes

;(function(FilterTypes) {
  FilterTypes["TextInput"] = "Text"
  FilterTypes["Picker"] = "Picker"
  FilterTypes["CheckboxGroup"] = "Checkbox"
  FilterTypes["Switch"] = "Switch"
  FilterTypes["ExcludableCheckboxGroup"] = "XCheckbox"
})(FilterTypes || (FilterTypes = {}))

export const isPickerValue = q => {
  return q.type === FilterTypes.Picker && typeof q.value === "string"
}

export const isCheckboxValue = q => {
  return q.type === FilterTypes.CheckboxGroup && Array.isArray(q.value)
}

export const isSwitchValue = q => {
  return q.type === FilterTypes.Switch && typeof q.value === "boolean"
}

export const isTextValue = q => {
  return q.type === FilterTypes.TextInput && typeof q.value === "string"
}

export const isXCheckboxValue = q => {
  return (
    q.type === FilterTypes.ExcludableCheckboxGroup &&
    typeof q.value === "object" &&
    !Array.isArray(q.value)
  )
}
