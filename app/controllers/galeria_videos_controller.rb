class GaleriaVideosController < ApplicationController
  before_action :set_galeria_video, only: [:show, :edit, :update, :destroy]

  # GET /galeria_videos
  # GET /galeria_videos.json
  def index
	@acesso=acesso(nil)
    @galeria_videos = GaleriaVideo.new.galeriaPermitirdaPorMenuUsuario(session[:usuario_id])
  end

  # GET /galeria_videos/1
  # GET /galeria_videos/1.json
  def show
	@acesso=acesso(@galeria_video.Menu_id)
  end

  # GET /galeria_videos/new
  def new
	@acesso=acesso(nil)
	@menus = Menu.new.menusPorNivel(">",session[:usuario_id])	
    @galeria_video = GaleriaVideo.new
  end

  # GET /galeria_videos/1/edit
  def edit
	@acesso=acesso(@galeria_video.Menu_id)
	@menus = Menu.new.menusPorNivel(">",session[:usuario_id])
  end

  # POST /galeria_videos
  # POST /galeria_videos.json
  def create
	@acesso=acesso(@galeria_video.Menu_id)
    @galeria_video = GaleriaVideo.new(galeria_video_params)

    respond_to do |format|
      if @galeria_video.save
        format.html { redirect_to @galeria_video, notice: 'Galeria video was successfully created.' }
        format.json { render :show, status: :created, location: @galeria_video }
      else
        format.html { render :new }
        format.json { render json: @galeria_video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /galeria_videos/1
  # PATCH/PUT /galeria_videos/1.json
  def update
	@acesso=acesso(@galeria_video.Menu_id)
    respond_to do |format|
      if @galeria_video.update(galeria_video_params)
        format.html { redirect_to @galeria_video, notice: 'Galeria video was successfully updated.' }
        format.json { render :show, status: :ok, location: @galeria_video }
      else
        format.html { render :edit }
        format.json { render json: @galeria_video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /galeria_videos/1
  # DELETE /galeria_videos/1.json
  def destroy
	@acesso=acesso(@galeria_video.Menu_id)
    @galeria_video.destroy
    respond_to do |format|
      format.html { redirect_to galeria_videos_url, notice: 'Galeria video was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_galeria_video
      @galeria_video = GaleriaVideo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def galeria_video_params
      params.require(:galeria_video).permit(:nome, :descricao, :link_youtube, :Menu_id)
    end
end
