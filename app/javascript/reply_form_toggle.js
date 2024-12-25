document.addEventListener('turbo:load', function () {
    const replyButtons = document.querySelectorAll('.reply-button');
  
    replyButtons.forEach(function (button) {
      button.addEventListener('click', function () {
        const commentId = button.dataset.commentId;
        const replyForm = document.querySelector(`#reply-form-${commentId}`);
  
        if (replyForm) {
          // Toggle visibility of the reply form
          replyForm.style.display = replyForm.style.display === 'none' || replyForm.style.display === '' ? 'block' : 'none';
        }
      });
    });
  });
  