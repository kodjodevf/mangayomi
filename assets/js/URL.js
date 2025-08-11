(function() {
  if (typeof URL != 'function') {
    rewriteURL();
  } else if (!('searchParams' in new URL(window.location))) {
    rewriteURL();
  }

  function rewriteURL() {

    // Overwrite URL if no searchParams property exists.
    this.URL = function(url, base) {

      var _hash;
      var _hostname;
      var _password;
      var _pathname;
      var _port;
      var _protocol;
      var _search;
      var _username;
      
      Object.defineProperty(this, 'hash', {
        get: function() {
          return _hash;
        },
        set: function(value) {
          _hash = value.length > 0 ? '#' + value.match(/^#*(.*)/)[1] : '';
          return value;
        }
      });
      
      Object.defineProperty(this, 'host', {
        get: function() {
          return _port.length > 0 ? _hostname + ':' + _port : _hostname;
        },
        set: function(value) {
          var parts = value.split(':');
          this.hostname = parts[0];
          this.port = parts[1];
          return value;
        }
      });
      
      Object.defineProperty(this, 'hostname', {
        get: function() {
          return _hostname;
        },
        set: function(value) {
          _hostname = value.length > 0 ? encodeURIComponent(value) : _hostname;
          return value;
        }
      });
      
      function removeUsername(match, username, password) {
        if (password === '@') {
          return '';
        } else {
          return password;
        }
      }
      
      Object.defineProperty(this, 'href', {
        get: function() {
          var hrefStr = _protocol + '//';
          if (_username.length > 0 || _password.length > 0) {
            if (_username.length > 0) {
              hrefStr += _username;
            }
            if (_password.length > 0) {
              hrefStr += ':' + _password;
            }
            hrefStr += '@'
          }
          hrefStr += _hostname;
          if (_port.length > 0) {
            hrefStr += ':' + _port;
          }
          hrefStr += _pathname + _search + _hash;
          return hrefStr;
        },
        set: function(value) {
        
          this.protocol = value;
          value = value.replace(/.*?:\/*/, '');
          
          var usernameMatch = value.match(/([^:]*).*@/);
          this.username = usernameMatch ? usernameMatch[1] : '';
          value = value.replace(/([^:]*):?(.*@)/, removeUsername);
          
          var passwordMatch = value.match(/.*(?=@)/);
          this.password = passwordMatch ? passwordMatch[0] : '';
          value = value.replace(/.*@/, '');
          
          this.hostname = value.match(/[^:/?]*/);
          
          var portMatch = value.match(/:(\d+)/);
          this.port = portMatch ? portMatch[1] : '';
          
          var pathnameMatch = value.match(/\/([^?#]*)/);
          this.pathname = pathnameMatch ? pathnameMatch[1] : '';
          
          var searchMatch = value.match(/\?[^#]*/);
          this.search = searchMatch ? searchMatch[0] : '';
          
          var hashMatch = value.match(/\#.*/);
          this.hash = hashMatch ? hashMatch[0] : '';
        }
      });
      
      Object.defineProperty(this, 'origin', {
        get: function() {
          var originStr = _protocol + '//' + _hostname;
          if (_port.length > 0) {
            originStr += ':' + _port;
          }
          return originStr;
        },
        set: function(value) {
        
          this.protocol = value;
          value = value.replace(/.*?:\/*/, '');
          
          this.hostname = value.match(/[^:/?]*/);
          
          var portMatch = value.match(/:(\d+)/);
          this.port = portMatch ? portMatch[1] : '';
        }
      });
      
      Object.defineProperty(this, 'password', {
        get: function() {
          return _password;
        },
        set: function(value) {
          _password = encodeURIComponent(value);
          return value;
        }
      });
      
      Object.defineProperty(this, 'pathname', {
        get: function() {
          return _pathname;
        },
        set: function(value) {
          _pathname = '/' + value.match(/\/?(.*)/)[1];
          return value;
        }
      });
      
      Object.defineProperty(this, 'port', {
        get: function() {
          return _port;
        },
        set: function(value) {
          if (isNaN(value) || value === '') {
            _port = '';
          } else {
            _port = Math.min(65535, value).toString();
          }
          return value;
        }
      });
      
      Object.defineProperty(this, 'protocol', {
        get: function() {
          return _protocol;
        },
        set: function(value) {
          _protocol = value.match(/[^/:]*/)[0] + ':';
          return value;
        }
      });
      
      Object.defineProperty(this, 'search', {
        get: function() {
          return _search;
        },
        set: function(value) {
          _search = value.length > 0 ? '?' + value.match(/\??(.*)/)[1] : '';
          return value;
        }
      });
      
      Object.defineProperty(this, 'username', {
        get: function() {
          return _username;
        },
        set: function(value) {
          _username = value;
        }
      });

      // If a string is passed for url instead of location or link, then set the 
      if (typeof url === 'string') {

        var urlIsValid = /^[a-zA-z]+:\/\/.*/.test(url);
        var baseIsValid = /^[a-zA-z]+:\/\/.*/.test(base);

        if (urlIsValid) {
          this.href = url;
        }

        // If the url isn't valid, but the base is, then prepend the base to the url.
        else if (baseIsValid) {
          this.href = base + url;
        }

        // If no valid url or base is given, then throw a type error.
        else {
          throw new TypeError('URL string is not valid. If using a relative url, a second argument needs to be passed representing the base URL. Example: new URL("relative/path", "http://www.example.com");');
        }

      } else {

        // Copy all of the location or link properties to the
        // new URL instance.
        _hash = url.hash;
        _hostname = url.hostname;
        _password = url.password ? url.password : '';
        _pathname = url.pathname;
        _port = url.port;
        _protocol = url.protocol;
        _search = url.search;
        _username = url.username ? url.username: '';

      }

      // Use IIFE to capture the URL instance and encapsulate the params instead of finding them
      // each time a searchParam method is called
      this.searchParams = (function(url) {

        // Create 2 seperate arrays for the params and values to make management and lookup easier.
        var params = [];
        var values = [];
        if (url.search.length > 0) {
          var pairs = url.search.slice(1).split('&');
          pairs.forEach(function(pair) {
            var parts = pair.split('=');
            params.push(parts[0]);
            values.push(parts[1]);
          });
        }
        
        // Update the search property of the URL instance with the new params and values.
        function updateSearchString() {
          if (params.length === 0) {
            url.search = '';
          } else {
            url.search = params.map(function(param, index) {
              return param + '=' + values[index];
            }).join('&');
          }
        }

        // Expose functions to mimic the behavior of the native searchParams methods.
        return {

          // Add a given param with a given value to the end.
          append: function(param, value) {
            params.push(param);
            values.push(value);
            updateSearchString();
          },

          // Remove all occurances of a given param
          delete: function(param) {
              while(params.indexOf(param) > -1) { // Continue until the param is not found.
                values.splice(params.indexOf(param), 1);
                params.splice(params.indexOf(param), 1);
              }
              updateSearchString();
          },

          // Return an array to be structured in this way: [[param1, value1], [param2, value2]] to
          // mimic the native method's ES6 iterator.
          entries: function() {
            return params.map(function(param, index) {
              return [param, values[index]];
            });
          },

          // Return the value matched to the first occurance of a given param.
          get: function(param) {
            return values[params.indexOf(param)];
          },

          // Return all values matched to all occurances of a given param.
          getAll: function(param) {
            return values.filter(function(value, index) {
              return params[index] === param;
            });
          },

          // Return a boolean to indicate whether a given param exists.
          has: function(param) {
            return params.indexOf(param) > -1;
          },

          // Return an array of the param names to mimic the native method's ES6 iterator.
          keys: function() {
            return params;
          },

          // Set a given param to a given value.
          set: function set(param, value) {
            if (params.indexOf(param) === -1) {
              this.append(param,value); // If the given param doesn't already exist, append it.
            } else {

              var first = true;
              var newValues = [];

              // If the param already exists, change the value of the first occurance and remove any
              // remaining occurances.
              params = params.filter(function(currentParam, index) {

                // If the currentParam isn't the one being changed keep the param and it's current value.
                if (currentParam !== param) {
                  newValues.push(values[index]);
                  return true;
                }

                // If the currentParam matches the one being changed and it's the first one, keep the
                // param and change its value to the given one.
                else if (first) {
                  first = false;
                  newValues.push(value);
                  return true;
                }

                // If the currentParam matches the one being changed, but it's not the first, remove it.
                return false;
              });
              values = newValues;
              updateSearchString();
            }
          },

          // Sort all key/value pairs, if any, by their keys then by their values.
          sort: function() {

            // Call entries to make sorting easier, then rewrite the params and values in the new order.
            var sortedPairs = this.entries().sort();
            params = [];
            values = [];
            sortedPairs.forEach(function(pair) {
              params.push(pair[0]);
              values.push(pair[1]);
            })
            updateSearchString();
          },

          // Return the search string without the '?'.
          toString: function() {
            return url.search.slice(1);
          },

          // Return and array of the param values to mimic the native method's ES6 iterator..
          values: function() {
            return values;
          }
        };
      })(this);
    }
  }
})()