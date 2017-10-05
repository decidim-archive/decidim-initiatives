(function () {
  'use strict';

  var inviteUsersButton = document.querySelector('.invite-users-link');

  if (inviteUsersButton !== null) {
    inviteUsersButton.addEventListener('click', function (event) {
      var link = document.querySelector('#committee_link'),
          range = document.createRange();

      event.preventDefault();

      range.selectNode(link);
      window.getSelection().addRange(range);

      try {
        document.execCommand('copy');
      } catch (err) {
      }

      window.getSelection().removeAllRanges();
    });
  }
}());
