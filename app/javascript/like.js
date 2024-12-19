document.addEventListener('DOMContentLoaded', function () {
    const blogPostsContainer = document.querySelector('.blog-container'); // Target the correct container
  
    if (blogPostsContainer) {
      blogPostsContainer.addEventListener('click', function (event) {
        const target = event.target;
  
        if (target.classList.contains('like-button') || target.classList.contains('unlike-button')) {
          event.preventDefault();
  
          const blogPostId = target.dataset.blogPostId; // ID of the blog post
          const isLike = target.classList.contains('like-button'); // Check if it's a like action
          const url = isLike ? `/blog_posts/${blogPostId}/like` : `/blog_posts/${blogPostId}/unlike`;
  
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
                const likesCountElement = document.getElementById(`likes-count-${blogPostId}`);
                likesCountElement.textContent = data.likes_count;
  
                // Toggle button states
                if (isLike) {
                  target.classList.remove('like-button');
                  target.classList.add('unlike-button');
                  target.textContent = 'Unlike';
                } else {
                  target.classList.remove('unlike-button');
                  target.classList.add('like-button');
                  target.textContent = 'Like';
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
  
  
  