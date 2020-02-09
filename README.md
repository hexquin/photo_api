# Build a small Rails API with Serializers

## I. Description
1. Rails version: 5.2.3
2. Ruby version: 2.5.3
3. Database: Postgres
4. Describe:
- The goal of the API is to sends Photos back with the Comments associated.
- The API has 2 models:
  + Photo: The attributes will be the *title* and *photo_url_string* .
  + Comment: The attributes will be *content* and *owner* and *photo_id* .
- The association is a photo having **many comments** while a comment **belongs to** a photo.
## II. Setup
1. To generate the API using the command:
```
rails _5.2.3_ new photo_api --database=postgresql --api
```

- The flag **--database=postgresql** to indicate *Postgres* is used to save the data.
- The flag **--api** to **avoid** generating *the views* and *view helpers* since they are not necessary for an API.

2. Install gem **rack-cors**

- Navigate to the folder of the project.
- Edit the *Gemfile* :
```
gem 'rack-cors'
```
- Why we need to install this gem?
> What is CORS?
> CORS is **Cross Origin Resource Sharing**
> This gem allows CORS in the API. CORS prevents API calls from unknow origins. 

3. Install gem **active_model_serializers**
```
gem 'active_model_serializers'
```

- Why we need to install this gem?
> The serializer gem is used to structure the format of the data when requests are made.

4. Config CORS
- Navigate to *config/inintializers/cors.rb* and uncomment the following code:
```
Rails.application.config.middleware.insert_before 0, Rack:Cors do
  allow do
    origins '*'

    resource '*',
    headers: :any,
    methods: %i(get post put patch delete options head)
  end
end
```

*Explain this code:* Within the **allow** block, **origins '*'** is allowing from all origins as well as allowing GET, POST, PUT, PATCH, and DELETE requests to the API.

## III. Config database and create databsse
## IV. Setup models and controllers
1. Generate model Photo and Comment
```
rails g model Photo title photo_url_string
rails g model Comment content:text owner photo_id:integer
```

2. Define association between photo model and comment model
```
class Photo < ApplicationRecord
  has_many :comments
  validates_presence_of :title
end
```

```
class Comment < ApplicationRecord
  belongs_to :photo
end
```

3. Generate controllers Photos and Comments
```
rails g controller api/v1/Photos
rails g controller api/v1/Comments
```

Since this is the first version of the API, the controllers should be inside **api/v1** .

4. Update the controllers
```
class Api::V1::PhotosController < ApplicationController
  before_action :get_photo, only: %i(show update)
  def index
    @photos = Photo.all
    render json: @photos
  end
  def show
    render json: @photo
  end
  def update
    @photo.update(photo_params)
    if @photo.valid?
      render json: @photo
    else
      render json: { errors: @photo.errors.full_messages }
    end
  end
  private
    def photo_params
      params.require(:photo).permit(:title, :photo_url_string)
    end
    def get_photo
      @photo = Photo.find(params[:photo_id])
    end
end
```

*Explain this code:* 
> 1. All photos are rendered in the form of JSON
> 2. The **photo_params** represent the data received from the front-end
> 3. The **photo_params** method is permitting the keys *title* and *photo_url_string* whenever a PATCH request is made.

```
class Api::V1::CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    if @comment.valid?
      render json: @comment
    else
      render json: { errors: @comment.errors.full_messages }
    end
  end
  private
    def comment_params
      params.require(:comment).permit(:content, :owner, :photo_id)
    end
end
```

5. Update the routes
```
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :photos, only: %i(index show update) do
        resources :comments, only: :create
      end
    end
  end
end
```
6. Seed data
- Navigate to **db/seed.rb** and input some seed data:
```
photo1 = Photo.create(title: 'Heart', photo_url_string: 'https://images.unsplash.com/photo-1581022414232-7c2eb612b50f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2250&q=80')
photo2 = Photo.create(title: 'Baby', photo_url_string: 'https://images.unsplash.com/photo-1581095863507-f121a8693129?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2250&q=80')
comment1 = Comment.create(content: 'Awesome picture', owner: 'Unsplash 1', photo_id: photo1.id)
comment2 = Comment.create(content: 'Hmm, this is romantic picture', owner: 'Unsplash 2', photo_id: photo1.id)
comment3 = Comment.create(content: 'Haha picture', owner: 'Unsplash 3', photo_id: photo2.id)
comment4 = Comment.create(content: 'Not bad', owner: 'Unsplash 4', photo_id: photo2.id)
```

- Run command to create the data:
```
rails db:seed
```

7. Serialize attributes which JSON response
- Run command:
```
rails g serializer photo
```
- Navigate to **serializers/photo_serializer.rb** :
```
class PhotoSerializer < ActiveModel::Serializer
  attributes :title, :photo_url_string
end
```

- At this point, only **title** and **photo_url_string** are sent in the JSON response. With serializers, the response can be structured to include certain information. The problem with the missing **comments** still persists. The **comments** must be included. Let's update the photo serializer.
```
class PhotoSerializer < ActiveModel::Serializer
  has_many :comments
  attributes :title, :photo_url_string
end
```
- Serializer comment:
```
rails g serializer comment
```

```
class CommentSerializer < ActiveModel::Serializer
  attributes :content, :owner
end
```
## V. Working with Postman
1. Get request
2. POST/PATCH request
3. Delete request



