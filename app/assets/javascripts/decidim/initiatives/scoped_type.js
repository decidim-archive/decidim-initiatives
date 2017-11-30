$(document).ready(function () {
  'use strict';

  var typeSelector = $('[data-scope-selector]'),
      refresh,
      targetElement,
      currentValue,
      searchUrl;

  if (typeSelector.length) {
    targetElement = $('#' + typeSelector.data('scope-selector'));
    currentValue = typeSelector.data('scope-id');
    searchUrl = typeSelector.data('scope-search-url');

    if (targetElement.length) {
      refresh = function () {
        $.ajax({
          url: searchUrl,
          cache: false,
          dataType: 'html',
          data: {
            type_id: typeSelector.val(),
            selected: currentValue
          },
          success: function (data) {
            targetElement.html(data);
          }
        });
      };

      typeSelector.change(refresh);
      refresh();
    }
  }
});
