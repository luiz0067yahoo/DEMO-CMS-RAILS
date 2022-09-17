class SistemasController < ApplicationController
  before_action :set_sistema, only: [:show, :edit, :update, :destroy]

  # GET /sistemas
  # GET /sistemas.json
  def index
	@acesso=acesso(nil)
	@sistemas=nil
	if (params["Menu_id"].nil?)
		@sistemas = Sistema.all.page(params['page']).per(10)
	else
		@sistemas = Sistema.where(permisao_por_menu: true).page(params['page']).per(10)
	end
  end

  # GET /sistemas/1
  # GET /sistemas/1.json
  def show
	@acesso=acesso(nil)
  end

  # GET /sistemas/new
  def new
	@acesso=acesso(nil)
    @sistema = Sistema.new
  end

  # GET /sistemas/1/edit
  def edit
	@acesso=acesso(nil)
  end

  # POST /sistemas
  # POST /sistemas.json
  def create
	@acesso=acesso(nil)
    @sistema = Sistema.new(sistema_params)
    respond_to do |format|
      if @sistema.save
        format.html { redirect_to @sistema, notice: 'Sistema was successfully created.' }
        format.json { render :show, status: :created, location: @sistema }
      else
        format.html { render :new }
        format.json { render json: @sistema.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sistemas/1
  # PATCH/PUT /sistemas/1.json
  def update
	@acesso=acesso(nil)
    respond_to do |format|
      if @sistema.update(sistema_params)
        format.html { redirect_to @sistema, notice: 'Sistema was successfully updated.' }
        format.json { render :show, status: :ok, location: @sistema }
      else
        format.html { render :edit }
        format.json { render json: @sistema.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sistemas/1
  # DELETE /sistemas/1.json
  def destroy
	@acesso=acesso(nil)
    @sistema.destroy
    respond_to do |format|
      format.html { redirect_to sistemas_url, notice: 'Sistema was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sistema
	  @acesso=acesso(nil)  	
      @sistema = Sistema.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sistema_params
	  @acesso=acesso(nil)
      params.require(:sistema).permit(:nome)
    end
end
