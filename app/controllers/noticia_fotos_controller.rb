class NoticiaFotosController < ApplicationController
  before_action :set_noticia_foto, only: [:show, :edit, :update, :destroy]

  # GET /noticia_fotos
  # GET /noticia_fotos.json
  def index
    @acesso=acesso(nil)
    @noticia_fotos = NoticiaFoto.all
  end

  # GET /noticia_fotos/1
  # GET /noticia_fotos/1.json
  def show
  end

  # GET /noticia_fotos/new
  def new
    @acesso=acesso(nil)
    @noticia_foto = NoticiaFoto.new
  end

  # GET /noticia_fotos/1/edit
  def edit
  end

  # POST /noticia_fotos
  # POST /noticia_fotos.json
  def create
    @noticia=Noticia.where("id=0"+@noticia_foto.Noticia_id).first
    @acesso=acesso(@noticia.Menu_id)
    @noticia_foto = NoticiaFoto.new(noticia_foto_params)

    respond_to do |format|
      if @noticia_foto.save
        format.html { redirect_to @noticia_foto, notice: 'Noticia foto was successfully created.' }
        format.json { render :show, status: :created, location: @noticia_foto }
      else
        format.html { render :new }
        format.json { render json: @noticia_foto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /noticia_fotos/1
  # PATCH/PUT /noticia_fotos/1.json
  def update
    @noticia=Noticia.where("id=0"+@noticia_foto.Noticia_id).first
    @acesso=acesso(@noticia.Menu_id)
    respond_to do |format|
      if @noticia_foto.update(noticia_foto_params)
        format.html { redirect_to @noticia_foto, notice: 'Noticia foto was successfully updated.' }
        format.json { render :show, status: :ok, location: @noticia_foto }
      else
        format.html { render :edit }
        format.json { render json: @noticia_foto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /noticia_fotos/1
  # DELETE /noticia_fotos/1.json
  def destroy
    @noticia=Noticia.where("id=0"+@noticia_foto.Noticia_id).first
    @acesso=acesso(@noticia.Menu_id)
    @noticia_foto.destroy
    respond_to do |format|
      format.html { redirect_to noticia_fotos_url, notice: 'Noticia foto was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_noticia_foto
      @noticia_foto = NoticiaFoto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def noticia_foto_params
      params.require(:noticia_foto).permit(:nome, :descricao, :Noticia_id,:foto)
    end
end
