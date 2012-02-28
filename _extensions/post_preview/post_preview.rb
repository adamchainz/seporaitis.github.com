module Jekyll

  class Post
    def preview_content
      delimeter = '<!--more-->' 
      self.content.split(delimeter)[0]
    end
  end
  
  AOP.around(Post, :to_liquid) do |post_instance, args, proceed, abort|
    result = proceed.call
    result['preview'] = post_instance.preview_content
    result
  end
end
