(function () {
  'use strict';

  var inviteUsersButton = document.querySelector('#invite_users');

  inviteUsersButton.addEventListener('click', function(event) {
    var link = document.querySelector('#committee_link'),
        range = document.createRange();

    range.selectNode(link);
    window.getSelection().addRange(range);

    try {
      document.execCommand('copy');
    } catch(err) { }

    window.getSelection().removeAllRanges();
  });
}());
