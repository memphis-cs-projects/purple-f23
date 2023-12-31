class UsersController < ApplicationController
    before_action :authenticate_user!, except: [:home]
    before_action :require_login, only: [:history]
    before_action :set_user, only: [:edit, :update, :destroy]

    def history
      @orders = current_user.orders.includes(line_items: :birdhouse)
    end
    

    def require_login
        unless current_user
          flash[:error] = "You must be signed in to view the history."
          redirect_to new_user_session_path # Assumes you're using Devise for user management
        end
    end

    def edit
        # The form will automatically load with the @user instance
    end
    
    def update
        if @user.update(user_params)
          flash[:success] = 'Details updated successfully.'
          redirect_to edit_user_profile_path
        else
          render :edit
        end
    end
    
    def destroy
      @user = User.find(params[:id])
      if current_user == @user && !(current_user.role?)

    
        if @user.destroy
          redirect_to home_path, notice: "The account was deleted successfully"
        else
          redirect_to home_path, alert: "There was an error in deleting the account"
        end
      else
        redirect_to home_path, alert: "Admin account cannot be deleted"
      end
    end

    def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :contact_number)
        
    end
    
    private

    def set_user
      @user = current_user # Ensure this is correctly finding the logged-in user
    end
end
