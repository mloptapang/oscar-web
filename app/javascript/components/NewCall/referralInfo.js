import React, { useEffect, useState } from "react";
import { SelectInput, TextArea, TextInput, Checkbox, DateInput } from "../Commons/inputs";
import ConcernAddress from "./concernAddress";

export default props => {
  const {
    onChange,
    data: {
      users,
      client,
      referee,
      currentDistricts,
      currentCommunes,
      currentVillages,
      birthProvinces,
      currentProvinces,
      errorFields,
      refereeRelationships,
      addressTypes,
      phoneOwners, T
    }
  } = props;

  const refereeRelationshipOpts = refereeRelationships.map(relationship => ({ label: relationship.label, value: relationship.value }))
  const userLists = users.map(user => ({label: user[0], value: user[1], isFixed: user[2] === 'locked' ? true : false }))
  // const phoneOwnerOpts = [
  //   { label: "Test Phone", value: "Test Phone" }
  // ];
  const phoneOwnerOpts = phoneOwners.map(phone => ({ label: phone.label, value: phone.value }))

  // const emailOwnerOpts = [
  //   { label: "Test Email", value: "Test" }
  // ];
  // todo, to be updated
  const emailOwnerOpts = phoneOwners.map(phone => ({ label: phone.label, value: phone.value }))

  const genderLists = [
    { label: "Female", value: "female" },
    { label: "Male", value: "male" },
    { label: "Other", value: "other" },
    { label: "Unknown", value: "unknown" }
  ];
  const birthProvincesLists = birthProvinces.map(province => ({
    label: province[0],
    options: province[1].map(value => ({ label: value[0], value: value[1] }))
  }));
  const [districts, setDistricts] = useState(currentDistricts);
  const [communes, setCommunes] = useState(currentCommunes);
  const [villages, setVillages] = useState(currentVillages);

  const fetchData = (parent, data, child) => {
    $.ajax({
      type: "GET",
      url: `/api/${parent}/${data}/${child}`
    }).success(res => {
      const dataState = {
        districts: setDistricts,
        communes: setCommunes,
        villages: setVillages
      };
      dataState[child](res.data);
    });
  };

  // const onRelationshipChange = event => {
  //   const previousSelect = client.referee_relationship;
  //   const isSelf = event.data === "self";

  //   if (isSelf) {
  //     if (referee.province_id !== null)
  //       fetchData("provinces", referee.province_id, "districts");
  //     if (referee.district_id !== null)
  //       fetchData("districts", referee.district_id, "communes");
  //     if (referee.commune_id !== null)
  //       fetchData("communes", referee.commune_id, "villages");
  //   } else if (previousSelect === "self") {
  //     setDistricts([]);
  //     setCommunes([]);
  //     setVillages([]);
  //   }

  //   const fields = {
  //     outside: isSelf
  //       ? referee.outside
  //       : previousSelect === "self"
  //       ? false
  //       : client.outside,
  //     province_id: isSelf
  //       ? referee.province_id
  //       : previousSelect === "self"
  //       ? null
  //       : client.province_id,
  //     district_id: isSelf
  //       ? referee.district_id
  //       : previousSelect === "self"
  //       ? null
  //       : client.district_id,
  //     commune_id: isSelf
  //       ? referee.commune_id
  //       : previousSelect === "self"
  //       ? null
  //       : client.commune_id,
  //     village_id: isSelf
  //       ? referee.village_id
  //       : previousSelect === "self"
  //       ? null
  //       : client.village_id,
  //     street_number: isSelf
  //       ? referee.street_number
  //       : previousSelect === "self"
  //       ? ""
  //       : client.street_number,
  //     house_number: isSelf
  //       ? referee.house_number
  //       : previousSelect === "self"
  //       ? ""
  //       : client.house_number,
  //     current_address: isSelf
  //       ? referee.current_address
  //       : previousSelect === "self"
  //       ? ""
  //       : client.current_address,
  //     address_type: isSelf
  //       ? referee.address_type
  //       : previousSelect === "self"
  //       ? ""
  //       : client.address_type,
  //     outside_address: isSelf
  //       ? referee.outside_address
  //       : previousSelect === "self"
  //       ? ""
  //       : client.outside_address
  //   };

  //   onChange("client", { ...fields, referee_relationship: event.data })({
  //     type: "select"
  //   });
  // };

  // useEffect(() => {
  //   const isSelf = client.referee_relationship === 'self'

  //   if(isSelf) {
  //     if(referee.province_id !== null)
  //       fetchData('provinces', referee.province_id, 'districts')
  //     if(referee.district_id !== null)
  //       fetchData('districts', referee.district_id, 'communes')
  //     if(referee.commune_id !== null)
  //       fetchData('communes', referee.commune_id, 'villages')
  //   }

  //   const fields = {
  //     outside: isSelf ? referee.outside : false,
  //     province_id: isSelf ? referee.province_id : null,
  //     district_id: isSelf ? referee.district_id : null,
  //     commune_id: isSelf ? referee.commune_id : null,
  //     village_id: isSelf ? referee.village_id : null,
  //     street_number: isSelf ? referee.street_number : '',
  //     house_number: isSelf ? referee.house_number : '',
  //     current_address: isSelf ? referee.current_address : '',
  //     address_type: isSelf ? referee.address_type : '',
  //     outside_address: isSelf ? referee.outside_address : ''
  //   }

  //   onChange('client', { ...fields })({type: 'select'})
  // }, [client.referee_relationship, referee])

  return (
    <div className="containerClass">
      <legend>
        <div className="row">
          <div className="col-xs-12 col-md-6 col-lg-4">
            <p>Client / Referral Information</p>
          </div>
        </div>
      </legend>

      <div className="row">
        <div className="col-xs-12 col-md-6 col-lg-3">
          <TextInput
            T={T}
            label="Given Name (Latin)"
            onChange={onChange("client", "given_name")}
            value={client.given_name}
          />
        </div>
        <div className="col-xs-12 col-md-6 col-lg-3">
          <TextInput
            T={T}
            label="Family Name (Latin)"
            onChange={onChange("client", "family_name")}
            value={client.family_name}
          />
        </div>
        <div className="col-xs-12 col-md-6 col-lg-3">
          <TextInput
            T={T}
            label="Given Name(Khmer)"
            onChange={onChange("client", "local_given_name")}
            value={client.local_given_name}
          />
        </div>
        <div className="col-xs-12 col-md-6 col-lg-3">
          <TextInput
            T={T}
            label="Family Name (Khmer)"
            onChange={onChange("client", "local_family_name")}
            value={client.local_family_name}
          />
        </div>
        <div className="col-xs-12 col-md-6 col-lg-3">
          <TextInput
            T={T}
            label="Nickname"
            onChange={onChange("client", "nickname")}
            value={client.nickname}
          />
        </div>
        <div className="col-xs-12 col-md-6 col-lg-3">
          <DateInput getCurrentDate label="Date of Birth" onChange={onChange('client', 'date_of_birth')} value={client.date_of_birth} />
        </div>
        <div className="col-xs-12 col-md-6 col-lg-3">
          <SelectInput
            T={T}
            required
            isError={errorFields.includes("gender")}
            label="Gender"
            options={genderLists}
            value={client.gender}
            onChange={onChange("client", "gender")}
          />
        </div>
        <div className="col-xs-12 col-md-6 col-lg-3">
          {/* <DateInput getCurrentDate label="Date of Birth" onChange={onChange('client', 'date_of_birth')} value={client.date_of_birth} /> */}
        </div>
        <div className="col-xs-12 col-md-6 col-lg-3">
          <SelectInput
            T={T}
            asGroup
            label="Birth Province"
            options={birthProvincesLists}
            value={client.birth_province_id}
            onChange={onChange("client", "birth_province_id")}
          />
        </div>

        <div className="col-xs-12 col-md-6 col-lg-3">
          {/* <SelectInput
            T={T}
            label="Relationship to Caller"
            options={refereeRelationshipOpts}
            value={client.referee_relationship}
            onChange={onRelationshipChange}
          /> */}
          <SelectInput
            T={T}
            label="Relationship to Caller"
            options={refereeRelationshipOpts}
            value={client.referee_relationship}
            onChange={onChange('client', 'referee_relationship')}
          />
        </div>
        <div className="col-xs-12 col-md-6 col-lg-3">
          <SelectInput
            T={T}
            required
            isError={errorFields.includes('user_ids')}
            label={T.translate("admin.case_worker")}
            isMulti
            options={userLists}
            value={client.user_ids}
            onChange={onChange('client','user_ids')} />
        </div>
      </div>
      <legend>
        <div className="row">
          <div className="col-xs-12 col-md-6 col-lg-3">
            <p>Location of concern</p>
          </div>
          {/* {client.referee_relationship !== "self" && (
            <div className="col-xs-12 col-md-6 col-lg-6">
              <Checkbox
                label="Concern is outside Cambodia"
                checked={client.concern_is_outside || false}
                onChange={onChange("client", "concern_is_outside")}
              />
            </div>
          )} */}
          <div className="col-xs-12 col-md-6 col-lg-6">
            <Checkbox
              label="Concern is outside Cambodia"
              checked={client.concern_is_outside || false}
              onChange={onChange("client", "concern_is_outside")}
            />
          </div>
        </div>
      </legend>

      {/* Todo: The following address should be fields of client obj. e.g
      concern_province_id, concern_district_id, concern_commune_id,
      concern_village_id */}
      {/* Found out that it currently overrides client address field */}
      <ConcernAddress
        // disabled={client.referee_relationship === "self"}
        outside={client.concern_is_outside || false}
        onChange={onChange}
        data={{
          addressTypes,
          currentDistricts: districts,
          currentCommunes: communes,
          currentVillages: villages,
          currentProvinces,
          objectKey: "client",
          objectData: client
        }}
      />

      <div className="row">
        <div className="col-xs-12 col-md-6">
          <div className="row">
            <div className="col-xs-12 col-md-6">
              <TextInput
                T={T}
                label="Relevant Contact Phone"
                onChange={onChange("client", "concern_phone")}
                value={client.concern_phone}
              />
            </div>
            <div className="col-xs-12 col-md-6">
              <SelectInput
                T={T}
                label="Phone Owner"
                options={phoneOwnerOpts}
                value={client.concern_phone_owner}
                onChange={onChange("client", "concern_phone_owner")}
              />
            </div>
          </div>
          <div className="row">
            <div className="col-xs-12 col-md-6">
              <TextInput
                T={T}
                label="Relevant Email Contact"
                onChange={onChange("client", "concern_email")}
                value={client.concern_email}
              />
            </div>
            <div className="col-xs-12 col-md-6">
              <SelectInput
                T={T}
                label="Email Owner"
                options={emailOwnerOpts}
                value={client.concern_email_owner}
                onChange={onChange("client", "concern_email_owner")}
              />
            </div>
          </div>
        </div>
        <div className={"col-xs-12 col-md-6" + (client.concern_is_outside ? ' hidden' : '')}>
          <TextArea
            label="Location Description"
            value={client.concern_location}
            onChange={onChange('client', 'concern_location')} />
        </div>
      </div>
    </div>
  );
};
