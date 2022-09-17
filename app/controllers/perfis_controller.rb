class PerfisController < ApplicationController
  before_action :set_perfil, only: [:show, :edit, :update, :destroy]

  # GET /perfis
  # GET /perfis.json
  def index
	@acesso=acesso(nil)
    @perfis = Perfil.all.page(params['page']).per(10)
  end

  # GET /perfis/1
  # GET /perfis/1.json
  def show
	@acesso=acesso(nil)
  end

  # GET /perfis/new
  def new
	@acesso=acesso(nil)
    @perfil = Perfil.new
  end

  # GET /perfis/1/edit
  def edit
	@acesso=acesso(nil)
  end

  # POST /perfis
  # POST /perfis.json
  def create
	@acesso=acesso(nil)
    @perfil = Perfil.new(perfil_params)
    respond_to do |format|
      if @perfil.save
        format.html { redirect_to @perfil, notice: 'Perfil was successfully created.' }
        format.json { render :show, status: :created, location: @perfil }
      else
        format.html { render :new }
        format.json { render json: @perfil.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /perfis/1
  # PATCH/PUT /perfis/1.json
  def update
	@acesso=acesso(nil)
    respond_to do |format|
      if @perfil.update(perfil_params)
        format.html { redirect_to @perfil, notice: 'Perfil was successfully updated.' }
        format.json { render :show, status: :ok, location: @perfil }
      else
        format.html { render :edit }
        format.json { render json: @perfil.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /perfis/1
  # DELETE /perfis/1.json
  def destroy
	@acesso=acesso(nil)
    @perfil.destroy
    respond_to do |format|
      format.html { redirect_to perfis_url, notice: 'Perfil was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_perfil
	  @acesso=acesso(nil) 	
      @perfil = Perfil.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def perfil_params
	  @acesso=acesso(nil)	
      params.require(:perfil).permit(:nome)
    end
end
