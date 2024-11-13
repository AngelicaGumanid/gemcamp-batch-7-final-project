import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ['selectedRegionId', 'selectProvinceId', 'selectCityId', 'selectBarangayId'];

    fetchProvinces() {
        let target = this.selectProvinceIdTarget;
        $(target).empty();

        let placeholderOption = document.createElement('option');
        placeholderOption.value = '';
        placeholderOption.text = 'Please select province';
        placeholderOption.selected = true;
        target.appendChild(placeholderOption);

        $.ajax({
            type: 'GET',
            url: '/api/v1/regions/' + this.selectedRegionIdTarget.value + '/provinces',
            dataType: 'json',
            success: (response) => {
                console.log('Provinces Response:', response);
                $.each(response, function (index, record) {
                    let option = document.createElement('option');
                    option.value = record.id;
                    option.text = record.name;
                    target.appendChild(option);
                });
            },
            error: (err) => {
                console.error('Error fetching provinces:', err);
            }
        });
    }

    fetchCities() {
        let target = this.selectCityIdTarget;
        $(target).empty();

        let placeholderOption = document.createElement('option');
        placeholderOption.value = '';
        placeholderOption.text = 'Please select city';
        placeholderOption.selected = true;
        target.appendChild(placeholderOption);

        $.ajax({
            type: 'GET',
            url: '/api/v1/provinces/' + this.selectProvinceIdTarget.value + '/cities',
            dataType: 'json',
            success: (response) => {
                console.log('Cities Response:', response);
                $.each(response, function (index, record) {
                    let option = document.createElement('option');
                    option.value = record.id;
                    option.text = record.name;
                    target.appendChild(option);
                });
            },
            error: (err) => {
                console.error('Error fetching cities:', err);
            }
        });
    }

    fetchBarangays() {
        let target = this.selectBarangayIdTarget;
        $(target).empty();

        let placeholderOption = document.createElement('option');
        placeholderOption.value = '';
        placeholderOption.text = 'Please select barangay';
        placeholderOption.selected = true;
        target.appendChild(placeholderOption);

        $.ajax({
            type: 'GET',
            url: '/api/v1/cities/' + this.selectCityIdTarget.value + '/barangays',
            dataType: 'json',
            success: (response) => {
                console.log('Barangays Response:', response);
                $.each(response, function (index, record) {
                    let option = document.createElement('option');
                    option.value = record.id;
                    option.text = record.name;
                    target.appendChild(option);
                });
            },
            error: (err) => {
                console.error('Error fetching barangays:', err);
            }
        });
    }
}
