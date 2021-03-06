_         = require 'underscore'
util      = require 'util'
matchers  = require './matchers'

validateField = (path, value, spec) ->
  if not value?
    return (if spec.optional then null else {path: path, error: 'required'})
  m = matchers[spec.match]
  if not m
    {path: path, error: "matcher <#{spec.match}> is not defined"}
  else
    error = m(value, spec)
    if error then {path, value, error} else null

validateHierarchy = (path, obj, schema) ->
  # Testing primitives (no keys)
  if schema.match
    return validateField path, obj, schema
  # If the schema has object keys
  return _.map schema, (spec, key) ->
    fullPath = if path then "#{path}.#{key}" else key
    # Leaf specification
    if spec.match
      return validateField fullPath, obj[key], spec
    # Nested schema = missing
    if not obj[key]
      return {path: fullPath, error: 'required'}
    # Nested schema = array
    if util.isArray spec
      if not util.isArray obj[key]
        return {path: fullPath, error: 'should be an array'}
      return obj[key].map (val, i) -> validateHierarchy "#{fullPath}[#{i}]", val, spec[0]
    # Nested schema = object
    return validateHierarchy fullPath, obj[key], spec

module.exports = (obj, schema) ->
  errors = validateHierarchy '', obj, schema
  _.compact _.flatten errors
