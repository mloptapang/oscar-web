describe 'Donor' do
  let!(:admin){ create(:user, roles: 'admin') }
  let!(:donor){ create(:donor) }
  let!(:other_donor){ create(:donor) }
  before do
    login_as(admin)
  end

  feature 'List' do
    before do
      visit donors_path
    end
    scenario 'name' do
      expect(page).to have_content(donor.name)
      expect(page).to have_content(other_donor.name)
    end
    scenario 'new link ' do
      expect(page).to have_link('Add New Donor', new_donor_path)
    end
    scenario 'edit link' do
      expect(page).to have_css("i[class='fa fa-pencil']")
    end
    scenario 'delete link' do
      expect(page).to have_css("a[href='#{donor_path(donor)}'][data-method='delete']")
    end
  end

  # feature 'Create', js: true do
  #   before do
  #     visit departments_path
  #   end
  #   scenario 'valid' do
  #     click_link('New Department')
  #     within('#new_department') do
  #       fill_in 'Name', with: FFaker::Name.name
  #       click_button 'Save'
  #     end
  #     wait_for_ajax
  #     expect(page).to have_content('Department has been successfully created.')
  #   end
  #   scenario 'invalid' do
  #     click_link('New Department')
  #     within('#new_department') do
  #       click_button 'Save'
  #     end
  #     wait_for_ajax
  #     expect(page).to have_content('Failed to create a department')
  #   end
  # end
  #
  # feature 'Edit', js: true do
  #   let!(:name){ FFaker::Name.name }
  #   before do
  #     visit departments_path
  #   end
  #   scenario 'valid' do
  #     find("a[data-target='#departmentModal-#{department.id}']").click
  #     within("#departmentModal-#{department.id}") do
  #       fill_in 'Name', with: name
  #       click_button 'Save'
  #     end
  #     wait_for_ajax
  #     expect(page).to have_content('Department has been successfully updated')
  #   end
  #   scenario 'invalid' do
  #     find("a[data-target='#departmentModal-#{department.id}']").click
  #     within("#departmentModal-#{department.id}") do
  #       fill_in 'Name', with: ''
  #       click_button 'Save'
  #     end
  #     wait_for_ajax
  #     expect(page).to have_content(I18n.t('departments.update.failed_update'))
  #   end
  # end
  #
  # feature 'Delete', js: true do
  #   before do
  #     visit departments_path
  #   end
  #   scenario 'success' do
  #     find("a[href='#{department_path(department)}'][data-method='delete']").click
  #     wait_for_ajax
  #     expect(page).to have_content('Department has been successfully deleted')
  #   end
  #   scenario 'disable' do
  #     expect(page).to have_css("a[href='#{department_path(other_department)}'][data-method='delete'][class='btn btn-outline btn-danger btn-xs disabled']")
  #   end
  # end
end
