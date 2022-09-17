require "application_system_test_case"

class NoticiaVideosTest < ApplicationSystemTestCase
  setup do
    @noticia_video = noticia_videos(:one)
  end

  test "visiting the index" do
    visit noticia_videos_url
    assert_selector "h1", text: "Noticia Videos"
  end

  test "creating a Noticia video" do
    visit noticia_videos_url
    click_on "New Noticia Video"

    fill_in "Noticia", with: @noticia_video.Noticia_id
    fill_in "Descricao", with: @noticia_video.descricao
    fill_in "Link Youtube", with: @noticia_video.link_youtube
    fill_in "Nome", with: @noticia_video.nome
    click_on "Create Noticia video"

    assert_text "Noticia video was successfully created"
    click_on "Back"
  end

  test "updating a Noticia video" do
    visit noticia_videos_url
    click_on "Edit", match: :first

    fill_in "Noticia", with: @noticia_video.Noticia_id
    fill_in "Descricao", with: @noticia_video.descricao
    fill_in "Link Youtube", with: @noticia_video.link_youtube
    fill_in "Nome", with: @noticia_video.nome
    click_on "Update Noticia video"

    assert_text "Noticia video was successfully updated"
    click_on "Back"
  end

  test "destroying a Noticia video" do
    visit noticia_videos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Noticia video was successfully destroyed"
  end
end
