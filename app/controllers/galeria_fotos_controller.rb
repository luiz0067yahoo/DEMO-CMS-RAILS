class GaleriaFotosController < ApplicationController
  before_action :set_galeria_foto, only: [:show, :edit, :update, :destroy]

  # GET /galeria_fotos
  # GET /galeria_fotos.json
  def index
	  @acesso=acesso(nil)
    @galeria_fotos=GaleriaFoto.new.galeriaPermitirdaPorMenuUsuario(session[:usuario_id]) 
  end

  # GET /galeria_fotos/1
  # GET /galeria_fotos/1.json
  def show
    @menus = Menu.new.menusPorNivel(">",session[:usuario_id])
	  @acesso=acesso(@galeria_foto.Menu_id)
  end

  # GET /galeria_fotos/new
  def new
	  @acesso=acesso(nil)
	  @menus = Menu.new.menusPorNivel(">",session[:usuario_id])
    @galeria_foto = GaleriaFoto.new
  end

  # GET /galeria_fotos/1/edit
  def edit
	  @acesso=acesso(@galeria_foto.try(:Menu_id))
	  @menus = Menu.new.menusPorNivel(">",session[:usuario_id])
  end

  # POST /galeria_fotos
  # POST /galeria_fotos.json
  def create
    @menus = Menu.new.menusPorNivel(">",session[:usuario_id])
	  @acesso=acesso(@galeria_foto.try(:Menu_id))
    @galeria_foto = GaleriaFoto.new(galeria_foto_params)

    respond_to do |format|
      if @galeria_foto.save
        format.html { redirect_to @galeria_foto, notice: 'Galeria foto was successfully created.' }
        format.json { render :show, status: :created, location: @galeria_foto }
      else
        format.html { render :new }
        format.json { render json: @galeria_foto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /galeria_fotos/1
  # PATCH/PUT /galeria_fotos/1.json
  def update
    @menus = Menu.new.menusPorNivel(">",session[:usuario_id])
	  @acesso=acesso(@galeria_foto.Menu_id)
    respond_to do |format|
      if @galeria_foto.update(galeria_foto_params)
        format.html { redirect_to @galeria_foto, notice: 'Galeria foto was successfully updated.' }
        format.json { render :show, status: :ok, location: @galeria_foto }
      else
        format.html { render :edit }
        format.json { render json: @galeria_foto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /galeria_fotos/1
  # DELETE /galeria_fotos/1.json
  def destroy
	@acesso=acesso(@galeria_foto.Menu_id)
    @galeria_foto.destroy
    respond_to do |format|
      format.html { redirect_to galeria_fotos_url, notice: 'Galeria foto was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_galeria_foto
      @galeria_foto = GaleriaFoto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def galeria_foto_params
      params.require(:galeria_foto).permit(:nome, :descricao, :Menu_id,:foto)
    end 
end
