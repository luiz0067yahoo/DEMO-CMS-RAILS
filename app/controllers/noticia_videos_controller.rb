class NoticiaVideosController < ApplicationController
  before_action :set_noticia_video, only: [:show, :edit, :update, :destroy]

  # GET /noticia_videos
  # GET /noticia_videos.json
  def index
    @noticia_videos = NoticiaVideo.all
  end

  # GET /noticia_videos/1
  # GET /noticia_videos/1.json
  def show
  end

  # GET /noticia_videos/new
  def new
    @noticia_video = NoticiaVideo.new
  end

  # GET /noticia_videos/1/edit
  def edit
  end

  # POST /noticia_videos
  # POST /noticia_videos.json
  def create
    @noticia_video = NoticiaVideo.new(noticia_video_params)

    respond_to do |format|
      if @noticia_video.save
        format.html { redirect_to @noticia_video, notice: 'Noticia video was successfully created.' }
        format.json { render :show, status: :created, location: @noticia_video }
      else
        format.html { render :new }
        format.json { render json: @noticia_video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /noticia_videos/1
  # PATCH/PUT /noticia_videos/1.json
  def update
    respond_to do |format|
      if @noticia_video.update(noticia_video_params)
        format.html { redirect_to @noticia_video, notice: 'Noticia video was successfully updated.' }
        format.json { render :show, status: :ok, location: @noticia_video }
      else
        format.html { render :edit }
        format.json { render json: @noticia_video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /noticia_videos/1
  # DELETE /noticia_videos/1.json
  def destroy
    @noticia_video.destroy
    respond_to do |format|
      format.html { redirect_to noticia_videos_url, notice: 'Noticia video was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_noticia_video
      @noticia_video = NoticiaVideo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def noticia_video_params
      params.require(:noticia_video).permit(:nome, :descricao, :link_youtube, :Noticia_id)
    end
end
