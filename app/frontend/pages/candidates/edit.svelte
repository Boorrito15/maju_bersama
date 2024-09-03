<script lang="ts">
  import { Button } from "$lib/components/ui/button";
  import * as Card from "$lib/components/ui/card";
  import { Input } from "$lib/components/ui/input";
  import { Label } from "$lib/components/ui/label";
  import { Textarea } from "$lib/components/ui/textarea";
  import * as Select from "$lib/components/ui/select";
  import { useForm } from "@inertiajs/svelte";
  import axios from 'axios';
  import {
    saveOrUpdateCandidateDisability,
    initializeNewCandidateDisability,
    prepareCandidateDisabilityForEdit
  } from "$lib/candidateDisabilityUtils";

  export let candidate
  export let user
  export let experiences = [];
  export let candidate_disabilities = [];
  export let disabilities = [];
  export let disability_details = [];
  export let disability_options = disabilities;
  // export let languages
  export let candidate_languages = []

  let selectedLanguages = candidate_languages.map(lang => lang.id);

  let form = useForm({
    candidate: {
      first_name: candidate?.first_name || '',
      last_name: candidate?.last_name || '',
      date_of_birth: candidate?.date_of_birth || '',
    },
    user: {
      phone: user?.phone || '',
      address: user?.address || '',
      city: user?.city || '',
      state: user?.state || '',
      zip_code: user?.zip_code || '',
      country: user?.country || '',
      bio: user?.bio || '',
    },
    experiences: experiences || [],
    candidate_disabilities: candidate_disabilities || [],
    disability_details: disability_details || [],
    candidate_languages: candidate_languages || []
  });

  let currentStep = 0;
  let editingExperience = null;
  let editingDisability = null;
  let showExperienceForm = false;
  let showDisabilityForm = false;

  const steps = [
    { href: '#personal-info', title: 'Informasi Pribadi', description: 'Perbarui detail pribadi Anda.' },
    { href: '#contact-info', title: 'Informasi Kontak', description: 'Perbarui detail kontak Anda.' },
    { href: '#additional-info', title: 'Informasi Tambahan', description: 'Berikan informasi tambahan tentang diri Anda.' },
    { href: '#experiences', title: 'Pengalaman', description: 'Tambahkan dan perbarui pengalaman kerja Anda.' },
    { href: '#disabilities', title: 'Disabilitas', description: 'Tambahkan dan perbarui informasi mengenai disabilitas Anda.' }
  ];

  function handleStepChange(step: number) {
    currentStep = step;
  }

  function goToNextStep() {
    if (currentStep < steps.length - 1) {
      currentStep += 1;
    }
  }

  function goToPreviousStep() {
    if (currentStep > 0) {
      currentStep -= 1;
    }
  }

  function addExperience() {
    showExperienceForm = true;
    editingExperience = { id: null, job_title: '', company_name: '', start_date: '', end_date: '', description: '' };
  }

  async function saveExperience() {
    try {
      let response;
      if (!editingExperience.id) {
        response = await axios.post(`/candidates/${candidate.id}/experiences`, editingExperience);
        $form.experiences = [...$form.experiences, { ...response.data }];
      } else {
        response = await axios.put(`/candidates/${candidate.id}/experiences/${editingExperience.id}`, editingExperience);
        $form.experiences = $form.experiences.map(exp => exp.id === editingExperience.id ? { ...response.data } : exp);
      }
      showExperienceForm = false;
      editingExperience = null;
    } catch (error) {
      console.error('Failed to save experience:', error);
    }
  }

  function editExperience(experience) {
    editingExperience = { ...experience };
    showExperienceForm = true;
  }

  function cancelEdit() {
    showExperienceForm = false;
    showDisabilityForm = false;
    editingExperience = null;
    editingDisability = null;
  }

  function addNewDisability() {
    showDisabilityForm = true;
    editingDisability = initializeNewCandidateDisability(disabilities);
  }

  async function saveDisability() {
    const result = await saveOrUpdateCandidateDisability(candidate.id, editingDisability, $form);
    if (result && result.success) {
      $form.candidate_disabilities = [...$form.candidate_disabilities];
      disability_details = $form.candidate_disabilities.map(cd => {
        const foundDisability = disability_options.find(disability => disability.id === Number(cd.disability_id));
        return {
          id: cd.id,
          disability_id: cd.disability_id,
          details: cd.details,
          disability_name: foundDisability ? foundDisability.name : 'Unknown'
        };
      });
      showDisabilityForm = false;
      editingDisability = null;
    }
  }

  function editCandidateDisability(disability) {
    editingDisability = prepareCandidateDisabilityForEdit(disability);
    showDisabilityForm = true;
  }

  function selectDisability(event) {
    editingDisability.disability_id = event.detail.value;
  }

  function submit() {
    $form.put(`/candidates/${candidate.id}`, {
      onSuccess: () => { console.log('Form submitted successfully'); },
      onError: (errors) => { console.error('Form submission failed', errors); }
    });
  }

  $: cardTitle = steps[currentStep].title;
  $: cardDescription = steps[currentStep].description;
</script>

<div class="flex">
  <nav class="w-1/4 pr-4 space-y-2 text-left">
    <ul>
      {#each steps as item, index}
        {@const isActive = currentStep === index}
        <li>
          <a href={item.href} class={`block w-full p-2 rounded-md ${isActive ? 'bg-black text-white' : 'text-black'}`} on:click={() => handleStepChange(index)}>
            {item.title}
          </a>
        </li>
      {/each}
    </ul>
  </nav>

  <div class="w-3/4 p-4">
    <form on:submit|preventDefault={submit}>
      <Card.Root>
        <Card.Header>
          <Card.Title>{cardTitle}</Card.Title>
          <Card.Description>{cardDescription}</Card.Description>
        </Card.Header>
        <Card.Content>
          {#if candidate && user}
            <div class="space-y-4">
              {#if currentStep === 0}
                <div>
                  <Label for="first_name">Nama Depan</Label>
                  <Input id="first_name" bind:value={$form.candidate.first_name} placeholder="First Name" />
                  {#if $form.errors['candidate.first_name']}
                    <div class="text-sm text-red-500">{$form.errors['candidate.first_name']}</div>
                  {/if}
                </div>

                <div>
                  <Label for="last_name">Nama Belakang</Label>
                  <Input id="last_name" bind:value={$form.candidate.last_name} placeholder="Last Name" />
                  {#if $form.errors['candidate.last_name']}
                    <div class="text-sm text-red-500">{$form.errors['candidate.last_name']}</div>
                  {/if}
                </div>

                <div>
                  <Label for="date_of_birth">Tanggal Lahir</Label>
                  <Input id="date_of_birth" type="date" bind:value={$form.candidate.date_of_birth} />
                  {#if $form.errors['candidate.date_of_birth']}
                    <div class="text-sm text-red-500">{$form.errors['candidate.date_of_birth']}</div>
                  {/if}
                </div>

                <!-- <div>
                  <label for="languages">Bahasa</label>
                  <Select.Root on:selectedChange={selectLanguage}>
                    <Select.Trigger class="w-[180px]">
                      <Select.Value placeholder="Select Languages" />
                    </Select.Trigger>
                    <Select.Content>
                      {#each languages as language}
                        <Select.Item value={language.id} on:click={() => editingLanguage.language_id = language.id}>
                          {language.name}
                        </Select.Item>
                      {/each}
                    </Select.Content>
                  </Select.Root>

                  {#if $form.errors['candidate.languages']}
                    <div class="text-sm text-red-500">{$form.errors['candidate.languages']}</div>
                  {/if}
                </div> -->

              {:else if currentStep === 1}
                <div>
                  <Label for="phone">No. Telepon</Label>
                  <Input id="phone" bind:value={$form.user.phone} placeholder="Phone" />
                  {#if $form.errors['user.phone']}
                    <div class="text-sm text-red-500">{$form.errors['user.phone']}</div>
                  {/if}
                </div>

                <div>
                  <Label for="address">Alamat</Label>
                  <Input id="address" bind:value={$form.user.address} placeholder="Address" />
                  {#if $form.errors['user.address']}
                    <div class="text-sm text-red-500">{$form.errors['user.address']}</div>
                  {/if}
                </div>

                <div>
                  <Label for="city">Kota</Label>
                  <Input id="city" bind:value={$form.user.city} placeholder="City" />
                  {#if $form.errors['user.city']}
                    <div class="text-sm text-red-500">{$form.errors['user.city']}</div>
                  {/if}
                </div>

                <div>
                  <Label for="state">Provinci</Label>
                  <Input id="state" bind:value={$form.user.state} placeholder="State" />
                  {#if $form.errors['user.state']}
                    <div class="text-sm text-red-500">{$form.errors['user.state']}</div>
                  {/if}
                </div>

                <div>
                  <Label for="zip_code">Kode Pos</Label>
                  <Input id="zip_code" bind:value={$form.user.zip_code} placeholder="Zip Code" />
                  {#if $form.errors['user.zip_code']}
                    <div class="text-sm text-red-500">{$form.errors['user.zip_code']}</div>
                  {/if}
                </div>

                <!-- <div>
                  <Label for="country">Country</Label>
                  <Input id="country" bind:value={$form.user.country} placeholder="Country" />
                  {#if $form.errors['user.country']}
                    <div class="text-sm text-red-500">{$form.errors['user.country']}</div>
                  {/if}
                </div> -->

              {:else if currentStep === 2}
                <div class="grid gap-3">
                  <Label for="bio">Bio</Label>
                  <Textarea id="bio" bind:value={$form.user.bio} placeholder="Ceritakan tentang diri Anda" class="min-h-32" />
                  {#if $form.errors['user.bio']}
                    <div class="text-sm text-red-500">{$form.errors['user.bio']}</div>
                  {/if}
                </div>

              {:else if currentStep === 3}
                <div class="space-y-6">
                  {#if !showExperienceForm}
                    <Button type="button" on:click={addExperience}>+ Tambah Pengalaman Baru
                    </Button>
                  {/if}

                  {#if showExperienceForm}
                    <div class="mb-4 p-4 border rounded-md space-y-4">
                      <div>
                        <Label for="job_title">Judul Pekerjaan</Label>
                        <Input id="job_title" bind:value={editingExperience.job_title} placeholder="Judul Pekerjaan" />
                      </div>

                      <div>
                        <Label for="company_name">Nama Perusahaan</Label>
                        <Input id="company_name" bind:value={editingExperience.company_name} placeholder="Nama Perusahaan" />
                      </div>

                      <div>
                        <Label for="start_date">Tanggal Mulai</Label>
                        <Input id="start_date" type="date" bind:value={editingExperience.start_date} />
                      </div>

                      <div>
                        <Label for="end_date">Tanggal Akhir</Label>
                        <Input id="end_date" type="date" bind:value={editingExperience.end_date} />
                      </div>

                      <div>
                        <Label for="description">Deskripsi</Label>
                        <Textarea id="description" bind:value={editingExperience.description} placeholder="Deskripsi" />
                      </div>

                      <div class="flex justify-between">
                        <Button type="button" on:click={saveExperience} color="blue">Simpan</Button>
                        <Button type="button" on:click={cancelEdit} color="gray">Batal</Button>
                      </div>
                    </div>
                  {/if}

                  {#each $form.experiences as experience, index (experience.id)}
                    <div class="mb-4 p-4 border rounded-md space-y-2">
                      {#if editingExperience && editingExperience.id === experience.id}
                        <div class="space-y-4">
                          <div>
                            <Label for="job_title">Judul Pekerjaan</Label>
                            <Input id="job_title" bind:value={editingExperience.job_title} placeholder="Judul Pekerjaan" />
                          </div>

                          <div>
                            <Label for="company_name">Nama Perusahaan</Label>
                            <Input id="company_name" bind:value={editingExperience.company_name} placeholder="Nama Perusahaan" />
                          </div>

                          <div>
                            <Label for="start_date">Tanggal Mulai</Label>
                            <Input id="start_date" type="date" bind:value={editingExperience.start_date} />
                          </div>

                          <div>
                            <Label for="end_date">Tanggal Akhir</Label>
                            <Input id="end_date" type="date" bind:value={editingExperience.end_date} />
                          </div>

                          <div>
                            <Label for="description">Deskripsi</Label>
                            <Textarea id="description" bind:value={editingExperience.description} placeholder="Deskripsi" />
                          </div>

                          <div class="flex justify-between">
                            <Button type="button" on:click={cancelEdit} color="gray">Batal</Button>
                            <Button type="button" on:click={saveExperience} color="blue">Simpan</Button>
                          </div>
                        </div>
                      {:else}
                        <div class="flex justify-between items-start">
                          <div>
                            <h4>{experience.job_title}</h4>
                            <p class="font-semibold text-gray-500">{experience.company_name}</p>
                            <p>{experience.start_date} to {experience.end_date}</p>
                            <p>{experience.description}</p>
                          </div>
                          <Button type="button" class="ml-4" on:click={() => editExperience(experience)}>Edit</Button>
                        </div>
                      {/if}
                    </div>
                  {/each}
                </div>

              {:else if currentStep === 4}
                <div class="space-y-6">
                  {#if !showDisabilityForm}
                    <Button type="button" on:click={addNewDisability}>+ Tambah Disabilitas</Button>
                  {/if}

                  {#if showDisabilityForm}
                    <div class="mb-4 p-4 border rounded-md space-y-4">
                      <div>
                        <Label for="disability_id">Disabilitas</Label>
                        <Select.Root on:selectedChange={selectDisability}>
                          <Select.Trigger class="w-[180px]">
                            <Select.Value placeholder="Pilih Disabilitas" />
                          </Select.Trigger>
                          <Select.Content>
                            {#each disability_options as disability}
                              <Select.Item value={disability.id} on:click={() => editingDisability.disability_id = disability.id}>
                                {disability.name}
                              </Select.Item>
                            {/each}
                          </Select.Content>
                        </Select.Root>
                      </div>

                      <div>
                        <Label for="details">Detail</Label>
                        <Textarea id="details" bind:value={editingDisability.details} placeholder="Detail tentang disabilitas" />
                      </div>

                      <div class="flex justify-between">
                        <Button type="button" on:click={saveDisability} color="blue">Simpan</Button>
                        <Button type="button" on:click={cancelEdit} color="gray">Batal</Button>
                      </div>
                    </div>
                  {/if}

                  {#each disability_details as disabilityDetail, index (disabilityDetail.id)}
                    <div class="mb-4 p-4 border rounded-md space-y-2">
                      {#if editingDisability && editingDisability.id === disabilityDetail.id}
                        <div class="space-y-4">
                          <div>
                            <Label for="disability_id">Disabilitas</Label>
                            <Select.Root on:selectedChange={selectDisability}>
                              <Select.Trigger class="w-[180px]">
                                <Select.Value placeholder="Pilih Disabilitas" />
                              </Select.Trigger>
                              <Select.Content>
                                {#each disability_options as disability}
                                  <Select.Item value={disability.id} on:click={() => editingDisability.disability_id = disability.id}>
                                    {disability.name}
                                  </Select.Item>
                                {/each}
                              </Select.Content>
                            </Select.Root>
                          </div>

                          <div>
                            <Label for="details">Detail</Label>
                            <Textarea id="details" bind:value={editingDisability.details} placeholder="Detail tentang disabilitas" />
                          </div>

                          <div class="flex justify-between">
                            <Button type="button" on:click={cancelEdit} color="gray">Batal</Button>
                            <Button type="button" on:click={saveDisability} color="blue">Simpan</Button>
                          </div>
                        </div>
                      {:else}
                        <div class="flex justify-between items-start">
                          <div>
                            <h4>{disabilityDetail.disability_name}</h4>
                            <p>{disabilityDetail.details}</p>
                          </div>
                          <Button type="button" class="ml-4" on:click={() => editCandidateDisability(disabilityDetail)}>Edit</Button>
                        </div>
                      {/if}
                    </div>
                  {/each}
                </div>
              {/if}
            </div>
          {:else}
            <p>Loading...</p>
          {/if}
        </Card.Content>
        <Card.Footer class="px-6 py-4">
          <div class="flex justify-between w-full">
            {#if currentStep > 0}
              <Button type="button" on:click={goToPreviousStep}>Sebelumnya</Button>
            {/if}
            {#if currentStep < steps.length - 1}
              <Button type="button" on:click={goToNextStep}>Berikutnya</Button>
            {/if}
          </div>
        </Card.Footer>

      </Card.Root>

      <!-- Place the Save button outside the Card.Root but still inside the form -->
      <div class="mt-4 mx-auto w-full">
        <Button class="w-full bg-green-600" type="submit" disabled={$form.processing}>Simpan</Button>
      </div>
    </form>


  </div>
</div>
