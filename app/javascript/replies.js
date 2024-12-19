document.addEventListener('DOMContentLoaded', function () {
  const commentsSection = document.querySelector('.comments-section'); // Target the comments section container

  if (commentsSection) {
    commentsSection.addEventListener('click', function (event) {
      const target = event.target;

      if (target.classList.contains('like-comment-button') || target.classList.contains('unlike-comment-button')) {
        event.preventDefault();

        const commentId = target.dataset.commentId; // ID of the comment
        const blogPostId = target.dataset.blogPostId; // ID of the blog post
        const isLike = target.classList.contains('like-comment-button'); // Check if it's a like action
        const url = isLike 
          ? `/blog_posts/${blogPostId}/comments/${commentId}/like` 
          : `/blog_posts/${blogPostId}/comments/${commentId}/unlike`;

        fetch(url, {
          method: 'POST',
          headers: {
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
            'Accept': 'application/json',
          },
        })
          .then((response) => {
            if (!response.ok) throw new Error('Network response was not ok');
            return response.json();
          })
          .then((data) => {
            if (data.likes_count !== undefined) {
              // Update the likes count in the UI
              const likesCountElement = target.closest('.comment-actions').querySelector('.likes-count');
              likesCountElement.textContent = ` ${data.likes_count}`;

              // Toggle button states
              if (isLike) {
                target.classList.remove('like-comment-button');
                target.classList.add('unlike-comment-button');
                target.innerHTML = `<i class="fas fa-heart"></i>`; // Full heart icon
              } else {
                target.classList.remove('unlike-comment-button');
                target.classList.add('like-comment-button');
                target.innerHTML = `<i class="far fa-heart"></i>`; // Outline heart icon
              }
            } else if (data.error) {
              console.error(data.error);
            }
          })
          .catch((error) => {
            console.error('Error:', error);
          });
      }
    });
  }
});

  