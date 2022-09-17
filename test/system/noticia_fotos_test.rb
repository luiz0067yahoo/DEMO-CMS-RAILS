require "application_system_test_case"

class NoticiaFotosTest < ApplicationSystemTestCase
  setup do
    @noticia_foto = noticia_fotos(:one)
  end

  test "visiting the index" do
    visit noticia_fotos_url
    assert_selector "h1", text: "Noticia Fotos"
  end

  test "creating a Noticia foto" do
    visit noticia_fotos_url
    click_on "New Noticia Foto"

    fill_in "Noticia", with: @noticia_foto.Noticia_id
    fill_in "Descricao", with: @noticia_foto.descricao
    fill_in "Nome", with: @noticia_foto.nome
    click_on "Create Noticia foto"

    assert_text "Noticia foto was successfully created"
    click_on "Back"
  end

  test "updating a Noticia foto" do
    visit noticia_fotos_url
    click_on "Edit", match: :first

    fill_in "Noticia", with: @noticia_foto.Noticia_id
    fill_in "Descricao", with: @noticia_foto.descricao
    fill_in "Nome", with: @noticia_foto.nome
    click_on "Update Noticia foto"

    assert_text "Noticia foto was successfully updated"
    click_on "Back"
  end

  test "destroying a Noticia foto" do
    visit noticia_fotos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Noticia foto was successfully destroyed"
  end
end
