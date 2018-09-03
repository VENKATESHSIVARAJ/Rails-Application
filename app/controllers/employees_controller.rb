require "employee_details"

class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  #load_and_authorize_resource
  before_action :authenticate_user!
  # GET /employees
  # GET /employees.json
  def index
    
    id = Employee.find_by user_id: current_user.id
    if id == nil
	   render "new" 
    end
    @employee = Employee.find_by user_id: current_user.id
   
  end

  # GET /employees/1
  # GET /employees/1.json
  def show

    @employeeDetails = Array.new
    employeeAll = Employee.all
    employeeAll.each do |emp|
	if emp.user_id != current_user.id
		user = User.find_by id: emp.user_id
		obj = EmployeeDetails.new(emp.id, emp.user_id, emp.firstname, emp.lastname, user.roles_mask)
		@employeeDetails.push(obj)
	end
    end

  end

  # GET /employees/new
  def new
    #@employee = Employee.new
  end

  # GET /employees/1/edit
  def edit

	#format.html { render :edit }
	if(@employee.user_id != current_user.id)		
		user = User.find_by id: @employee.user_id
		@empDetails = EmployeeDetails.new(@employee.id, @employee.user_id, @employee.firstname, @employee.lastname, user.roles_mask)
	else
		#flash[:alert] = "Invalid data"
		@empDetails = @employee
	end
	@employee = @empDetails	

  end

  # POST /employees
  # POST /employees.json
  def create
    @employee = Employee.new(employee_params)
    @employee.user_id = current_user.id
    #respond_to do |format|
      if @employee.save
	render "index"
        #format.html { redirect_to @employee, notice: 'Employee was successfully created.' }
        #format.json { render :show, status: :created, location: @employee }
      else
	flash[:alert] = "Invalid data"
	render "new"
        #format.html { render :new }
        #format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    #end
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
    #respond_to do |format|
	
	employee = Employee.find_by id: @employee.id
	user = User.find_by id: @employee.user_id
	employee.firstname = params[:firstname]
	employee.lastname = params[:lastname]
	user.roles_mask = params[:Role]
    if(user.roles_mask != nil)
      if employee.save && user.save
	@employee = Employee.find_by user_id: current_user.id
	render "index"
      else
	flash[:alert] = "Invalid data"
	render "edit"
      end
    else
	if employee.save
	@employee = Employee.find_by user_id: current_user.id
	render "index"
      else
	flash[:alert] = "Invalid data"
	render "edit"
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_url, notice: 'Employee was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
      params.require(:employee).permit(:firstname, :lastname)
    end
end
